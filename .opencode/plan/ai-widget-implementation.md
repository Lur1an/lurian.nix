# AI Widget Implementation Plan

## Overview

Adapt end-4/dots-hyprland AI widget for your NixOS/Hyprland setup using Quickshell with OpenAI-compatible API support.

## Directory Structure

```
home-manager/quickshell/
├── default.nix                    # Nix module
└── config/
    ├── shell.qml                  # Entry point
    ├── GlobalStates.qml           # Shared state management
    ├── services/
    │   ├── Ai.qml                 # Core AI singleton
    │   ├── KeyringStorage.qml     # API key storage
    │   └── ai/
    │       ├── AiModel.qml        # Model definition
    │       ├── AiMessageData.qml  # Message structure
    │       ├── ApiStrategy.qml    # Base interface
    │       └── OpenAiApiStrategy.qml
    ├── modules/
    │   └── sidebarLeft/
    │       ├── SidebarLeft.qml    # Panel container
    │       ├── AiChat.qml         # Chat UI
    │       └── AiMessage.qml      # Message component
    └── scripts/
        ├── show-ollama-models.sh  # Auto-detect local models
        └── keyring-lookup.sh      # API key retrieval
```

---

## File 1: home-manager/quickshell/default.nix

```nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.quickshell;
in {
  options.quickshell = {
    enable = lib.mkEnableOption "Quickshell desktop shell with AI widget";

    aiWidget = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable AI chat widget in the sidebar";
      };

      defaultModel = lib.mkOption {
        type = lib.types.str;
        default = "ollama-llama3.2";
        description = "Default AI model to use";
      };

      ollamaEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:11434/v1/chat/completions";
        description = "Ollama API endpoint";
      };

      openaiEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "https://api.openai.com/v1/chat/completions";
        description = "OpenAI API endpoint";
      };
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto-start Quickshell with Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      quickshell
      libsecret # For secret-tool (API key storage)
      jq # For JSON parsing in scripts
      curl # For API requests
    ];

    # Symlink the quickshell config directory
    xdg.configFile."quickshell".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/lurian.nix/home-manager/quickshell/config";

    # Add to Hyprland exec-once if autoStart is enabled
    wayland.windowManager.hyprland.settings.exec-once = lib.mkIf cfg.autoStart [
      "quickshell"
    ];

    # Add keybind to toggle sidebar
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, A, exec, quickshell -c toggle-sidebar"
    ];

    # Layer rules for the sidebar
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur, quickshell"
      "ignorezero, quickshell"
    ];
  };
}
```

---

## File 2: config/shell.qml

```qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import "services" as Services
import "modules/sidebarLeft" as SidebarLeft

ShellRoot {
    id: root

    // Global state for sidebar visibility
    property bool sidebarVisible: false

    // Command handler for toggle-sidebar
    Connections {
        target: Quickshell
        function onCommand(cmd) {
            if (cmd === "toggle-sidebar") {
                root.sidebarVisible = !root.sidebarVisible;
            }
        }
    }

    // Instantiate services
    Services.Ai { id: aiService }
    Services.KeyringStorage { id: keyringStorage }

    // Create sidebar for each screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: sidebarPanel
            required property var modelData
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
            }

            width: root.sidebarVisible ? 400 : 0
            visible: root.sidebarVisible

            WlrLayershell.layer: WlrLayershell.Overlay
            WlrLayershell.namespace: "quickshell-sidebar"
            WlrLayershell.keyboardFocus: WlrLayershell.OnDemand

            color: "transparent"

            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            SidebarLeft.SidebarLeft {
                anchors.fill: parent
                visible: root.sidebarVisible
            }
        }
    }
}
```

---

## File 3: config/services/ai/AiMessageData.qml

```qml
import QtQuick

QtObject {
    property string role           // "user", "assistant", "system", "interface"
    property string content        // Rendered content
    property string rawContent     // Raw content for API
    property string model          // Model that generated this
    property bool thinking: true   // Show loading indicator
    property bool done: false      // Response complete
    property var annotations: []   // Citations/links
    property string functionName   // For function calls
    property var functionCall      // Function call details
    property string functionResponse
    property bool functionPending: false  // Awaiting user approval
    property bool visibleToUser: true
}
```

---

## File 4: config/services/ai/AiModel.qml

```qml
import QtQuick

QtObject {
    property string name           // Display name
    property string icon           // Icon name
    property string description    // Model description
    property string endpoint       // API endpoint URL
    property string model          // Model identifier (e.g., "gpt-4", "llama3.2")
    property bool requires_key: true
    property string key_id         // Key identifier for keyring
    property string key_get_link   // URL to get API key
    property string key_get_description
    property string api_format: "openai"
    property var extraParams: ({})
}
```

---

## File 5: config/services/ai/ApiStrategy.qml

```qml
import QtQuick

QtObject {
    function buildEndpoint(model) { throw new Error("Not implemented") }
    function buildRequestData(model, messages, systemPrompt, temperature, tools) { throw new Error("Not implemented") }
    function buildAuthorizationHeader(apiKeyEnvVarName) { throw new Error("Not implemented") }
    function parseResponseLine(line, message) { throw new Error("Not implemented") }
    function onRequestFinished(message) { return {} }
    function reset() {}
}
```

---

## File 6: config/services/ai/OpenAiApiStrategy.qml

```qml
import QtQuick
import ".."

ApiStrategy {
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
        let cleanData = line.trim();
        if (cleanData.startsWith("data:")) {
            cleanData = cleanData.slice(5).trim();
        }

        if (!cleanData || cleanData.startsWith(":")) return {};
        if (cleanData === "[DONE]") {
            return { finished: true };
        }

        try {
            const dataJson = JSON.parse(cleanData);

            // Error handling
            if (dataJson.error) {
                const errorMsg = `**Error**: ${dataJson.error.message || JSON.stringify(dataJson.error)}`;
                message.rawContent += errorMsg;
                message.content += errorMsg;
                return { finished: true };
            }

            let newContent = "";

            const responseContent = dataJson.choices?.[0]?.delta?.content || dataJson.message?.content;
            const responseReasoning = dataJson.choices?.[0]?.delta?.reasoning || dataJson.choices?.[0]?.delta?.reasoning_content;

            // Handle reasoning/thinking blocks
            if (responseContent && responseContent.length > 0) {
                if (isReasoning) {
                    isReasoning = false;
                    message.content += "\n\n</think>\n\n";
                    message.rawContent += "\n\n</think>\n\n";
                }
                newContent = responseContent;
            } else if (responseReasoning && responseReasoning.length > 0) {
                if (!isReasoning) {
                    isReasoning = true;
                    message.rawContent += "\n\n<think>\n\n";
                    message.content += "\n\n<think>\n\n";
                }
                newContent = responseReasoning;
            }

            message.content += newContent;
            message.rawContent += newContent;

            // Token usage
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
            console.log("[AI] Could not parse line:", e);
            message.rawContent += line;
            message.content += line;
        }

        return {};
    }

    function onRequestFinished(message) {
        return {};
    }

    function reset() {
        isReasoning = false;
    }
}
```

---

## File 7: config/services/Ai.qml (Core Service - Simplified)

```qml
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "ai"

Singleton {
    id: root

    // Components
    property Component aiMessageComponent: AiMessageData {}
    property Component aiModelComponent: AiModel {}
    property Component openaiApiStrategy: OpenAiApiStrategy {}

    // Constants
    readonly property string interfaceRole: "interface"
    readonly property string apiKeyEnvVarName: "API_KEY"

    // Signals
    signal responseFinished()

    // State
    property string systemPrompt: "You are a helpful assistant integrated into a Linux desktop shell. Be concise and helpful. The user is running NixOS with Hyprland."
    property var messageIDs: []
    property var messageByID: ({})
    property var apiKeys: KeyringStorage.keyringData?.apiKeys ?? {}
    property bool apiKeysLoaded: KeyringStorage.loaded
    property real temperature: 0.7

    property QtObject tokenCount: QtObject {
        property int input: -1
        property int output: -1
        property int total: -1
    }

    // Models registry
    property var models: ({
        "ollama-llama3.2": aiModelComponent.createObject(root, {
            "name": "Llama 3.2 (Local)",
            "icon": "ollama-symbolic",
            "description": "Local Ollama model",
            "endpoint": "http://localhost:11434/v1/chat/completions",
            "model": "llama3.2",
            "requires_key": false,
        }),
        "openai-gpt4": aiModelComponent.createObject(root, {
            "name": "GPT-4",
            "icon": "openai-symbolic",
            "description": "OpenAI GPT-4",
            "endpoint": "https://api.openai.com/v1/chat/completions",
            "model": "gpt-4",
            "requires_key": true,
            "key_id": "openai",
            "key_get_link": "https://platform.openai.com/api-keys",
        }),
        "openai-gpt4o": aiModelComponent.createObject(root, {
            "name": "GPT-4o",
            "icon": "openai-symbolic",
            "description": "OpenAI GPT-4o (faster)",
            "endpoint": "https://api.openai.com/v1/chat/completions",
            "model": "gpt-4o",
            "requires_key": true,
            "key_id": "openai",
        }),
    })

    property var modelList: Object.keys(models)
    property string currentModelId: "ollama-llama3.2"
    property var currentApiStrategy: openaiApiStrategy.createObject(root)

    readonly property bool currentModelHasApiKey: {
        const model = models[currentModelId];
        if (!model || !model.requires_key) return true;
        if (!apiKeysLoaded) return false;
        const key = apiKeys[model.key_id];
        return (key?.length > 0);
    }

    // Auto-detect Ollama models
    Process {
        id: getOllamaModels
        running: true
        command: ["bash", "-c", "ollama list 2>/dev/null | tail -n +2 | awk '{print $1}' | jq -R -s -c 'split(\"\\n\") | map(select(length > 0))'"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    if (data.length === 0) return;
                    const models = JSON.parse(data);
                    models.forEach(model => {
                        const safeModelName = "ollama-" + model.replace(/:/g, "-").replace(/\//g, "-");
                        root.models[safeModelName] = root.aiModelComponent.createObject(root, {
                            "name": model + " (Local)",
                            "icon": "ollama-symbolic",
                            "description": "Local Ollama model",
                            "endpoint": "http://localhost:11434/v1/chat/completions",
                            "model": model,
                            "requires_key": false,
                        });
                    });
                    root.modelList = Object.keys(root.models);
                } catch (e) {
                    console.log("Could not fetch Ollama models:", e);
                }
            }
        }
    }

    // Helper functions
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
        root.messageIDs = [...root.messageIDs, id];
        root.messageByID[id] = aiMessage;
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

    function getModel() {
        return models[currentModelId];
    }

    function setModel(modelId, feedback = true) {
        modelId = modelId.toLowerCase();
        if (modelList.indexOf(modelId) !== -1) {
            currentModelId = modelId;
            if (feedback) {
                root.addMessage("Model set to " + models[modelId].name, root.interfaceRole);
            }
        } else {
            if (feedback) {
                root.addMessage("Invalid model. Available: " + modelList.join(", "), root.interfaceRole);
            }
        }
    }

    function setTemperature(value) {
        if (isNaN(value) || value < 0 || value > 2) {
            root.addMessage("Temperature must be between 0 and 2", root.interfaceRole);
            return;
        }
        root.temperature = value;
        root.addMessage("Temperature set to " + value, root.interfaceRole);
    }

    function setApiKey(key) {
        const model = models[currentModelId];
        if (!model.requires_key) {
            root.addMessage(model.name + " does not require an API key", root.interfaceRole);
            return;
        }
        if (!key || key.length === 0) {
            root.addMessage("Get your API key at: " + model.key_get_link, root.interfaceRole);
            return;
        }
        KeyringStorage.setNestedField(["apiKeys", model.key_id], key.trim());
        root.addMessage("API key set for " + model.name, root.interfaceRole);
    }

    // Request handling
    FileView {
        id: requesterScriptFile
    }

    Process {
        id: requester
        property list<string> baseCommand: ["bash"]
        property AiMessageData message
        property var currentStrategy

        function markDone() {
            requester.message.done = true;
            root.responseFinished();
        }

        function makeRequest() {
            const model = models[currentModelId];

            if (model?.requires_key && !KeyringStorage.loaded) {
                KeyringStorage.fetchKeyringData();
            }

            requester.currentStrategy = root.currentApiStrategy;
            requester.currentStrategy.reset();

            if (model.requires_key) {
                requester.environment[root.apiKeyEnvVarName] = root.apiKeys?.[model.key_id] ?? "";
            }

            const endpoint = requester.currentStrategy.buildEndpoint(model);
            const messageArray = root.messageIDs.map(id => root.messageByID[id]);
            const filteredMessageArray = messageArray.filter(msg => msg.role !== root.interfaceRole);
            const data = requester.currentStrategy.buildRequestData(model, filteredMessageArray, root.systemPrompt, root.temperature, []);

            // Create response message
            requester.message = root.aiMessageComponent.createObject(root, {
                "role": "assistant",
                "model": currentModelId,
                "content": "",
                "rawContent": "",
                "thinking": true,
                "done": false,
            });
            const id = idForMessage(requester.message);
            root.messageIDs = [...root.messageIDs, id];
            root.messageByID[id] = requester.message;

            // Build curl command
            const authHeader = requester.currentStrategy.buildAuthorizationHeader(root.apiKeyEnvVarName);
            const scriptContent = `#!/usr/bin/env bash
curl --no-buffer "${endpoint}" \\
  -H "Content-Type: application/json" \\
  ${authHeader ? authHeader : ""} \\
  --data '${JSON.stringify(data).replace(/'/g, "'\\''")}'
`;

            const shellScriptPath = "/tmp/quickshell/ai/request.sh";
            requesterScriptFile.path = Qt.resolvedUrl(shellScriptPath);
            requesterScriptFile.setText(scriptContent);
            requester.command = baseCommand.concat([shellScriptPath]);
            requester.running = true;
        }

        stdout: SplitParser {
            onRead: data => {
                if (data.length === 0) return;
                if (requester.message.thinking) requester.message.thinking = false;

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
                    requester.message.rawContent += data;
                    requester.message.content += data;
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            const result = requester.currentStrategy.onRequestFinished(requester.message);
            if (result.finished || !requester.message.done) {
                requester.markDone();
            }
        }
    }

    function sendUserMessage(message) {
        if (message.length === 0) return;
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

    Component.onCompleted: {
        // Create script directory
        const proc = Qt.createQmlObject('import Quickshell.Io; Process { }', root);
        proc.command = ["mkdir", "-p", "/tmp/quickshell/ai"];
        proc.running = true;
    }
}
```

---

## File 8: config/services/KeyringStorage.qml

```qml
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool loaded: false
    property var keyringData: ({})

    property var properties: ({
        "application": "quickshell-ai",
        "explanation": "For storing API keys",
    })

    function setNestedField(path, value) {
        if (!root.keyringData) root.keyringData = {};
        let keys = path;
        let obj = root.keyringData;
        let parents = [obj];

        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        obj[keys[keys.length - 1]] = value;

        for (let i = keys.length - 2; i >= 0; --i) {
            let parent = parents[i];
            let key = keys[i];
            parent[key] = Object.assign({}, parent[key]);
        }

        root.keyringData = Object.assign({}, root.keyringData);
        saveKeyringData();
    }

    function fetchKeyringData() {
        getData.running = true;
    }

    function saveKeyringData() {
        saveData.stdinEnabled = true;
        saveData.running = true;
    }

    Process {
        id: saveData
        command: [
            "secret-tool", "store",
            "--label=Quickshell AI Keys",
            "application", root.properties.application,
        ]
        onRunningChanged: {
            if (saveData.running) {
                saveData.write(JSON.stringify(root.keyringData));
                stdinEnabled = false;
            }
        }
    }

    Process {
        id: getData
        command: [
            "bash", "-c",
            "secret-tool lookup application quickshell-ai 2>/dev/null || echo '{}'"
        ]
        stdout: SplitParser {
            onRead: data => {
                if (data.length === 0 || !data.startsWith("{")) return;
                try {
                    root.keyringData = JSON.parse(data);
                } catch (e) {
                    console.error("[KeyringStorage] Failed to parse keyring data");
                    root.keyringData = {};
                }
            }
        }
        onExited: (exitCode, exitStatus) => {
            root.loaded = true;
        }
    }

    Component.onCompleted: {
        fetchKeyringData();
    }
}
```

---

## File 9: config/modules/sidebarLeft/SidebarLeft.qml

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: sidebar
    color: Qt.rgba(0, 0, 0, 0.8)
    radius: 12

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: Qt.rgba(1, 1, 1, 0.1)
            radius: 8

            Text {
                anchors.centerIn: parent
                text: "AI Assistant"
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
        }

        // AI Chat
        AiChat {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
```

---

## File 10: config/modules/sidebarLeft/AiChat.qml (Simplified UI)

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../services" as Services

Item {
    id: root

    property string commandPrefix: "/"

    property var allCommands: [
        { name: "model", description: "Set AI model", execute: args => Services.Ai.setModel(args[0]) },
        { name: "key", description: "Set API key", execute: args => Services.Ai.setApiKey(args[0]) },
        { name: "temp", description: "Set temperature", execute: args => Services.Ai.setTemperature(parseFloat(args[0])) },
        { name: "clear", description: "Clear chat", execute: () => Services.Ai.clearMessages() },
    ]

    function handleInput(inputText) {
        if (inputText.startsWith(root.commandPrefix)) {
            const command = inputText.split(" ")[0].substring(1);
            const args = inputText.split(" ").slice(1);
            const commandObj = root.allCommands.find(cmd => cmd.name === command);
            if (commandObj) {
                commandObj.execute(args);
            } else {
                Services.Ai.addMessage("Unknown command: " + command, Services.Ai.interfaceRole);
            }
        } else {
            Services.Ai.sendUserMessage(inputText);
        }
        messageListView.positionViewAtEnd();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Status bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: Qt.rgba(1, 1, 1, 0.05)
            radius: 6

            RowLayout {
                anchors.centerIn: parent
                spacing: 12

                Text {
                    text: Services.Ai.getModel()?.name ?? "No model"
                    color: "#aaa"
                    font.pixelSize: 11
                }

                Text {
                    text: "T: " + Services.Ai.temperature.toFixed(1)
                    color: "#aaa"
                    font.pixelSize: 11
                }

                Text {
                    visible: Services.Ai.tokenCount.total > 0
                    text: Services.Ai.tokenCount.total + " tokens"
                    color: "#aaa"
                    font.pixelSize: 11
                }
            }
        }

        // Message list
        ListView {
            id: messageListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

            model: Services.Ai.messageIDs.filter(id => {
                const message = Services.Ai.messageByID[id];
                return message?.visibleToUser ?? true;
            })

            delegate: AiMessage {
                required property var modelData
                required property int index
                width: messageListView.width
                messageData: Services.Ai.messageByID[modelData]
            }

            onContentHeightChanged: {
                if (atYEnd) Qt.callLater(positionViewAtEnd);
            }
        }

        // Placeholder when empty
        Text {
            visible: Services.Ai.messageIDs.length === 0
            Layout.alignment: Qt.AlignCenter
            text: "Type /key to set up API key\nor just start chatting with local Ollama"
            color: "#666"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        // Input area
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(inputField.implicitHeight + 20, 50)
            color: Qt.rgba(1, 1, 1, 0.1)
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                TextArea {
                    id: inputField
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: 'Message... "/" for commands'
                    color: "white"
                    placeholderTextColor: "#666"
                    wrapMode: TextArea.Wrap
                    background: null

                    Keys.onReturnPressed: event => {
                        if (event.modifiers & Qt.ShiftModifier) {
                            inputField.insert(inputField.cursorPosition, "\n");
                        } else {
                            const text = inputField.text.trim();
                            if (text.length > 0) {
                                root.handleInput(text);
                                inputField.clear();
                            }
                        }
                        event.accepted = true;
                    }
                }

                Button {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    enabled: inputField.text.trim().length > 0
                    text: ">"

                    onClicked: {
                        const text = inputField.text.trim();
                        if (text.length > 0) {
                            root.handleInput(text);
                            inputField.clear();
                        }
                    }
                }
            }
        }
    }
}
```

---

## File 11: config/modules/sidebarLeft/AiMessage.qml

```qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: messageItem
    property var messageData

    color: messageData?.role === "user" ? Qt.rgba(0.2, 0.4, 0.8, 0.3) :
           messageData?.role === "assistant" ? Qt.rgba(0.3, 0.3, 0.3, 0.5) :
           Qt.rgba(0.5, 0.5, 0.2, 0.3)
    radius: 8
    implicitHeight: contentLayout.implicitHeight + 16

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        // Role indicator
        Text {
            text: messageData?.role === "user" ? "You" :
                  messageData?.role === "assistant" ? (messageData?.model ?? "AI") :
                  "System"
            color: "#888"
            font.pixelSize: 10
            font.bold: true
        }

        // Message content
        Text {
            Layout.fillWidth: true
            text: messageData?.content ?? ""
            color: "white"
            font.pixelSize: 13
            wrapMode: Text.Wrap
            textFormat: Text.MarkdownText
        }

        // Loading indicator
        Text {
            visible: messageData?.thinking ?? false
            text: "..."
            color: "#888"
            font.pixelSize: 13

            SequentialAnimation on opacity {
                running: messageData?.thinking ?? false
                loops: Animation.Infinite
                NumberAnimation { to: 0.3; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }
        }
    }
}
```

---

## Integration: Update home-manager/profiles/linux.nix

Add to imports:
```nix
imports = [
  # ... existing imports
  ../quickshell
];
```

Add configuration:
```nix
quickshell = {
  enable = true;
  aiWidget.enable = true;
};
```

---

## Usage

After applying the configuration:

1. **Toggle sidebar**: `Super + A`
2. **Commands**:
   - `/model ollama-llama3.2` - Switch model
   - `/key sk-xxx` - Set OpenAI API key
   - `/temp 0.8` - Set temperature
   - `/clear` - Clear chat
3. **Chat**: Just type and press Enter

---

## Next Steps After Implementation

1. Add markdown rendering with syntax highlighting
2. Add function calling support (shell commands)
3. Add chat save/load
4. Add more models (Claude, etc.)
5. Add file attachment support
6. Improve theming with matugen colors
