import QtQuick

/**
 * OpenAI-compatible API strategy.
 * Works with OpenAI, Ollama, and any OpenAI-compatible endpoint.
 */
QtObject {
    id: strategy

    property bool isReasoning: false

    function buildEndpoint(model) {
        return model.endpoint;
    }

    function buildRequestData(model, messages, systemPrompt, temperature, tools) {
        let baseData = {
            "model": model.model,
            "messages": [
                { role: "system", content: systemPrompt },
                ...messages.map(message => ({
                    "role": message.role,
                    "content": message.rawContent,
                })),
            ],
            "stream": true,
            "temperature": temperature,
        };

        if (tools && tools.length > 0) {
            baseData.tools = tools;
        }

        return model.extraParams ? Object.assign({}, baseData, model.extraParams) : baseData;
    }

    function buildAuthorizationHeader(apiKeyEnvVarName) {
        return `-H "Authorization: Bearer \$\{${apiKeyEnvVarName}\}"`;
    }

    function parseResponseLine(line, message) {
        if (!message) {
            console.log("[AI Strategy] No message object!");
            return {};
        }

        let cleanData = line.trim();
        
        // Handle multiple data: lines in one read
        if (cleanData.includes("\ndata:")) {
            const lines = cleanData.split("\n");
            let result = {};
            for (const l of lines) {
                const r = parseResponseLine(l, message);
                if (r.finished) result.finished = true;
                if (r.tokenUsage) result.tokenUsage = r.tokenUsage;
            }
            return result;
        }
        
        if (cleanData.startsWith("data:")) {
            cleanData = cleanData.slice(5).trim();
        }

        // Handle special cases
        if (!cleanData || cleanData.startsWith(":")) return {};
        if (cleanData === "[DONE]") {
            console.log("[AI Strategy] Received [DONE]");
            return { finished: true };
        }

        try {
            const dataJson = JSON.parse(cleanData);

            // Error handling
            if (dataJson.error) {
                const errorMsg = `**Error**: ${dataJson.error.message || JSON.stringify(dataJson.error)}`;
                message.rawContent = message.rawContent + errorMsg;
                message.content = message.content + errorMsg;
                return { finished: true };
            }

            let newContent = "";

            const responseContent = dataJson.choices?.[0]?.delta?.content || dataJson.message?.content;
            const responseReasoning = dataJson.choices?.[0]?.delta?.reasoning || dataJson.choices?.[0]?.delta?.reasoning_content;

            // Handle reasoning/thinking blocks (for models like DeepSeek R1)
            if (responseContent && responseContent.length > 0) {
                if (strategy.isReasoning) {
                    strategy.isReasoning = false;
                    const endBlock = "\n\n</think>\n\n";
                    message.content = message.content + endBlock;
                    message.rawContent = message.rawContent + endBlock;
                }
                newContent = responseContent;
            } else if (responseReasoning && responseReasoning.length > 0) {
                if (!strategy.isReasoning) {
                    strategy.isReasoning = true;
                    const startBlock = "\n\n<think>\n\n";
                    message.rawContent = message.rawContent + startBlock;
                    message.content = message.content + startBlock;
                }
                newContent = responseReasoning;
            }

            if (newContent.length > 0) {
                console.log("[AI Strategy] Adding content:", newContent.substring(0, 50));
                // Must reassign to trigger QML property change notification
                message.content = message.content + newContent;
                message.rawContent = message.rawContent + newContent;
            }

            // Token usage metadata
            if (dataJson.usage) {
                return {
                    tokenUsage: {
                        input: dataJson.usage.prompt_tokens ?? -1,
                        output: dataJson.usage.completion_tokens ?? -1,
                        total: dataJson.usage.total_tokens ?? -1
                    }
                };
            }

            if (dataJson.done) {
                return { finished: true };
            }

        } catch (e) {
            console.log("[AI Strategy] Parse error:", e, "for line:", cleanData.substring(0, 100));
        }

        return {};
    }

    function onRequestFinished(message) {
        return {};
    }

    function reset() {
        strategy.isReasoning = false;
    }
}
