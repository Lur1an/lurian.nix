pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "ai"

/**
 * Core AI service singleton.
 * Simplified design: endpoint + key + model name = ready to chat
 */
Singleton {
    id: root

    // Components
    property Component aiMessageComponent: Component { AiMessageData {} }
    property Component openaiApiStrategy: Component { OpenAiApiStrategy {} }

    // Constants
    readonly property string interfaceRole: "interface"

    // Signals
    signal responseFinished()

    // ============== CONFIGURATION ==============
    // These are the main settings users need to configure
    
    property string endpoint: "http://localhost:11434/v1/chat/completions"  // Default to Ollama
    property string apiKey: ""
    property string modelName: "llama3.2"  // The actual model identifier sent to API
    property string displayName: "Ollama Local"  // Friendly name shown in UI
    property real temperature: 0.7
    property string systemPrompt: "You are a helpful AI assistant. Be concise and helpful."

    // Presets for quick switching
    property var presets: ({
        "ollama": {
            endpoint: "http://localhost:11434/v1/chat/completions",
            model: "llama3.2",
            name: "Ollama Local",
            needsKey: false
        },
        "openai": {
            endpoint: "https://api.openai.com/v1/chat/completions",
            model: "gpt-4o",
            name: "OpenAI GPT-4o",
            needsKey: true
        },
        "poe": {
            endpoint: "https://api.poe.com/v1/chat/completions",
            model: "gpt-4o",
            name: "Poe GPT-4o",
            needsKey: true
        },
        "openrouter": {
            endpoint: "https://openrouter.ai/api/v1/chat/completions",
            model: "anthropic/claude-3.5-sonnet",
            name: "OpenRouter Claude",
            needsKey: true
        }
    })

    // ============== STATE ==============
    property var messageIDs: []
    property var messageByID: ({})
    property var currentApiStrategy: openaiApiStrategy.createObject(root)

    property QtObject tokenCount: QtObject {
        property int input: -1
        property int output: -1
        property int total: -1
    }

    readonly property bool hasApiKey: apiKey.length > 0
    readonly property bool isLocalModel: endpoint.includes("localhost") || endpoint.includes("127.0.0.1")
    readonly property bool isReady: isLocalModel || hasApiKey

    // ============== HELPER FUNCTIONS ==============
    
    function idForMessage(message) {
        return Date.now().toString(36) + Math.random().toString(36).substr(2, 8);
    }

    function addMessage(message, role) {
        if (message.length === 0) return;
        const aiMessage = aiMessageComponent.createObject(root, {
            "role": role,
            "content": message,
            "rawContent": message,
            "thinking": false,
            "done": true,
        });
        const id = idForMessage(aiMessage);
        root.messageByID[id] = aiMessage;
        root.messageIDs = [...root.messageIDs, id];
        console.log("[AI] Added message, total:", root.messageIDs.length, "role:", role);
    }

    function removeMessage(index) {
        if (index < 0 || index >= messageIDs.length) return;
        const id = root.messageIDs[index];
        root.messageIDs.splice(index, 1);
        root.messageIDs = [...root.messageIDs];
        delete root.messageByID[id];
    }

    function clearMessages() {
        root.messageIDs = [];
        root.messageByID = ({});
        root.tokenCount.input = -1;
        root.tokenCount.output = -1;
        root.tokenCount.total = -1;
    }

    // ============== CONFIGURATION COMMANDS ==============

    function setEndpoint(url) {
        if (!url || url.length === 0) {
            addMessage("**Current endpoint:** `" + endpoint + "`\n\n**Usage:** `/endpoint URL`\n\n**Examples:**\n- `/endpoint https://api.openai.com/v1/chat/completions`\n- `/endpoint https://api.poe.com/v1/chat/completions`\n- `/endpoint http://localhost:11434/v1/chat/completions`", interfaceRole);
            return;
        }
        root.endpoint = url.trim();
        addMessage("Endpoint set to: `" + root.endpoint + "`", interfaceRole);
        saveConfig();
    }

    function setKey(key) {
        if (!key || key.length === 0) {
            if (apiKey.length > 0) {
                const masked = apiKey.substring(0, 8) + "..." + apiKey.substring(apiKey.length - 4);
                addMessage("**Current API key:** `" + masked + "`\n\n**Usage:** `/key YOUR_API_KEY`", interfaceRole);
            } else {
                addMessage("**No API key set.**\n\n**Usage:** `/key YOUR_API_KEY`\n\nGet keys from:\n- OpenAI: https://platform.openai.com/api-keys\n- Poe: https://poe.com/api_key\n- OpenRouter: https://openrouter.ai/settings/keys", interfaceRole);
            }
            return;
        }
        root.apiKey = key.trim();
        const masked = apiKey.substring(0, 8) + "..." + apiKey.substring(apiKey.length - 4);
        addMessage("API key set: `" + masked + "`", interfaceRole);
        saveConfig();
    }

    function setModel(name) {
        if (!name || name.length === 0) {
            addMessage("**Current model:** `" + modelName + "`\n**Display name:** " + displayName + "\n\n**Usage:** `/model MODEL_NAME`\n\n**Examples:**\n- `/model gpt-4o`\n- `/model claude-3.5-sonnet`\n- `/model llama3.2`\n\n**Quick presets:** `/preset ollama`, `/preset openai`, `/preset poe`", interfaceRole);
            return;
        }
        root.modelName = name.trim();
        root.displayName = name.trim();
        addMessage("Model set to: `" + root.modelName + "`", interfaceRole);
        saveConfig();
    }

    function setTemperature(value) {
        if (isNaN(value)) {
            addMessage("**Current temperature:** " + temperature.toFixed(1) + "\n\n**Usage:** `/temp VALUE` (0.0 to 2.0)\n- 0.0 = deterministic\n- 0.7 = balanced (default)\n- 2.0 = very creative", interfaceRole);
            return;
        }
        if (value < 0 || value > 2) {
            addMessage("Temperature must be between 0 and 2", interfaceRole);
            return;
        }
        root.temperature = value;
        addMessage("Temperature set to: " + value.toFixed(1), interfaceRole);
        saveConfig();
    }

    function usePreset(name) {
        if (!name || name.length === 0) {
            let presetList = "**Available presets:**\n\n";
            for (const key in presets) {
                const p = presets[key];
                presetList += "- `" + key + "` - " + p.name + (p.needsKey ? " (needs API key)" : "") + "\n";
            }
            presetList += "\n**Usage:** `/preset NAME`";
            addMessage(presetList, interfaceRole);
            return;
        }
        
        const preset = presets[name.toLowerCase()];
        if (!preset) {
            addMessage("Unknown preset: `" + name + "`\n\nUse `/preset` to see available presets.", interfaceRole);
            return;
        }
        
        root.endpoint = preset.endpoint;
        root.modelName = preset.model;
        root.displayName = preset.name;
        
        let msg = "Switched to **" + preset.name + "**\n- Endpoint: `" + preset.endpoint + "`\n- Model: `" + preset.model + "`";
        if (preset.needsKey && !hasApiKey) {
            msg += "\n\n**Note:** This preset requires an API key. Set it with `/key YOUR_KEY`";
        }
        addMessage(msg, interfaceRole);
        saveConfig();
    }

    function showStatus() {
        let status = "**Current Configuration:**\n\n";
        status += "- **Endpoint:** `" + endpoint + "`\n";
        status += "- **Model:** `" + modelName + "`\n";
        status += "- **API Key:** " + (hasApiKey ? "Set" : "Not set") + "\n";
        status += "- **Temperature:** " + temperature.toFixed(1) + "\n";
        status += "- **Status:** " + (isReady ? "Ready" : "Needs API key") + "\n";
        addMessage(status, interfaceRole);
    }

    function showHelp() {
        const help = `**Available Commands:**

**Setup:**
- \`/endpoint URL\` - Set API endpoint
- \`/key API_KEY\` - Set API key  
- \`/model NAME\` - Set model name
- \`/preset NAME\` - Use a preset (ollama, openai, poe, openrouter)

**Settings:**
- \`/temp VALUE\` - Set temperature (0-2)
- \`/system PROMPT\` - Set system prompt

**Other:**
- \`/status\` - Show current config
- \`/clear\` - Clear chat history
- \`/help\` - Show this help

**Quick Start:**
1. \`/preset openai\` (or poe, openrouter)
2. \`/key YOUR_API_KEY\`
3. Start chatting!`;
        addMessage(help, interfaceRole);
    }

    function setSystemPrompt(prompt) {
        if (!prompt || prompt.length === 0) {
            addMessage("**Current system prompt:**\n\n" + systemPrompt + "\n\n**Usage:** `/system YOUR_PROMPT`", interfaceRole);
            return;
        }
        root.systemPrompt = prompt;
        addMessage("System prompt updated.", interfaceRole);
        saveConfig();
    }

    // ============== PERSISTENCE ==============
    
    property string configPath: "/home/lurian/.cache/quickshell-ai/config.json"

    function saveConfig() {
        const config = {
            endpoint: root.endpoint,
            apiKey: root.apiKey,
            modelName: root.modelName,
            displayName: root.displayName,
            temperature: root.temperature,
            systemPrompt: root.systemPrompt
        };
        // Use process to write config
        const jsonStr = JSON.stringify(config, null, 2).replace(/'/g, "'\\''");
        configSaver.command = ["bash", "-c", `echo '${jsonStr}' > "${configPath}"`];
        configSaver.running = true;
    }

    Process {
        id: configSaver
    }

    Process {
        id: configLoader
        command: ["cat", configPath]
        stdout: SplitParser {
            splitMarker: ""  // Read all at once
            onRead: data => {
                console.log("[AI] Config data received:", data.substring(0, 100));
                try {
                    const config = JSON.parse(data);
                    if (config.endpoint) root.endpoint = config.endpoint;
                    if (config.apiKey) root.apiKey = config.apiKey;
                    if (config.modelName) root.modelName = config.modelName;
                    if (config.displayName) root.displayName = config.displayName;
                    if (config.temperature !== undefined) root.temperature = config.temperature;
                    if (config.systemPrompt) root.systemPrompt = config.systemPrompt;
                    console.log("[AI] Config loaded. Endpoint:", root.endpoint, "Model:", root.modelName);
                } catch (e) {
                    console.log("[AI] Failed to parse config:", e);
                }
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.log("[AI] No config file found, using defaults");
            }
        }
    }

    function loadConfig() {
        console.log("[AI] Loading config from:", configPath);
        configLoader.running = true;
    }

    // ============== REQUEST HANDLING ==============

    Process {
        id: requester
        property var message
        property var currentStrategy

        function markDone() {
            if (requester.message) {
                requester.message.done = true;
            }
            root.responseFinished();
        }

        function makeRequest() {
            requester.currentStrategy = root.currentApiStrategy;
            requester.currentStrategy.reset();

            // Set API key in environment
            if (root.apiKey.length > 0) {
                requester.environment["API_KEY"] = root.apiKey;
            }

            const messageArray = root.messageIDs.map(id => root.messageByID[id]);
            const filteredMessageArray = messageArray.filter(msg => msg.role !== root.interfaceRole);
            
            const data = {
                model: root.modelName,
                messages: [
                    { role: "system", content: root.systemPrompt },
                    ...filteredMessageArray.map(msg => ({
                        role: msg.role,
                        content: msg.rawContent
                    }))
                ],
                stream: true,
                temperature: root.temperature
            };

            // Create response message placeholder
            requester.message = root.aiMessageComponent.createObject(root, {
                "role": "assistant",
                "model": root.displayName,
                "content": "",
                "rawContent": "",
                "thinking": true,
                "done": false,
            });
            const id = root.idForMessage(requester.message);
            root.messageByID[id] = requester.message;
            root.messageIDs = [...root.messageIDs, id];
            console.log("[AI] Created assistant message placeholder, total:", root.messageIDs.length);

            // Build curl command directly - no script file needed
            const jsonData = JSON.stringify(data).replace(/'/g, "'\\''");
            
            let curlCmd = `curl --no-buffer -s "${root.endpoint}" -H "Content-Type: application/json"`;
            if (root.apiKey.length > 0) {
                curlCmd += ` -H "Authorization: Bearer ${root.apiKey}"`;
            }
            curlCmd += ` --data '${jsonData}'`;

            requester.command = ["bash", "-c", curlCmd];
            console.log("[AI] Running command:", JSON.stringify(requester.command));
            requester.running = true;
        }

        stdout: SplitParser {
            onRead: data => {
                console.log("[AI] stdout:", data);
                if (data.length === 0) return;
                if (requester.message && requester.message.thinking) {
                    requester.message.thinking = false;
                }

                try {
                    const result = requester.currentStrategy.parseResponseLine(data, requester.message);

                    if (result.tokenUsage) {
                        root.tokenCount.input = result.tokenUsage.input;
                        root.tokenCount.output = result.tokenUsage.output;
                        root.tokenCount.total = result.tokenUsage.total;
                    }
                    if (result.finished) {
                        requester.markDone();
                    }
                } catch (e) {
                    console.log("[AI] Could not parse response:", e);
                    if (requester.message) {
                        requester.message.rawContent = requester.message.rawContent + data;
                        requester.message.content = requester.message.content + data;
                    }
                }
            }
        }

        stderr: SplitParser {
            onRead: data => {
                console.log("[AI] stderr:", data);
                if (requester.message) {
                    requester.message.thinking = false;
                    requester.message.content = requester.message.content + "\n**Error:** " + data;
                    requester.message.rawContent = requester.message.rawContent + "\n**Error:** " + data;
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            console.log("[AI] Process exited with code:", exitCode);
            if (exitCode !== 0 && requester.message) {
                requester.message.content = requester.message.content + "\n**Process exited with code " + exitCode + "**";
                requester.message.thinking = false;
            }
            const result = requester.currentStrategy.onRequestFinished(requester.message);
            if (result.finished || (requester.message && !requester.message.done)) {
                requester.markDone();
            }
        }
    }

    function sendUserMessage(message) {
        if (message.length === 0) return;
        
        if (!isReady) {
            addMessage("**Not configured!** Use `/preset openai` then `/key YOUR_KEY` to get started.\n\nOr use `/help` for all commands.", interfaceRole);
            return;
        }
        
        root.addMessage(message, "user");
        requester.makeRequest();
    }

    function regenerate(messageIndex) {
        if (messageIndex < 0 || messageIndex >= messageIDs.length) return;
        const id = root.messageIDs[messageIndex];
        const message = root.messageByID[id];
        if (message.role !== "assistant") return;

        for (let i = root.messageIDs.length - 1; i >= messageIndex; i--) {
            root.removeMessage(i);
        }
        requester.makeRequest();
    }

    // ============== INITIALIZATION ==============

    Component.onCompleted: {
        // Create cache directory for config storage
        const proc = Qt.createQmlObject('import Quickshell.Io; Process { }', root);
        proc.command = ["mkdir", "-p", "/home/lurian/.cache/quickshell-ai"];
        proc.running = true;
        
        // Load saved config
        loadConfig();
    }
}
