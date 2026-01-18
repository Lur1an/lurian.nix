import QtQuick

/**
 * Base interface for API strategies.
 * All methods must be implemented by concrete strategies.
 */
QtObject {
    function buildEndpoint(model) {
        throw new Error("Not implemented");
    }

    function buildRequestData(model, messages, systemPrompt, temperature, tools) {
        throw new Error("Not implemented");
    }

    function buildAuthorizationHeader(apiKeyEnvVarName) {
        throw new Error("Not implemented");
    }

    function parseResponseLine(line, message) {
        throw new Error("Not implemented");
    }

    function onRequestFinished(message) {
        return {};
    }

    function reset() {}
}
