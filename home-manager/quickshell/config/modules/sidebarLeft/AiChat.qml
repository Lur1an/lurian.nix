import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../services"

/**
 * AI Chat interface component.
 * Styled with pywal-generated colors.
 */
Item {
    id: root

    property string commandPrefix: "/"
    property var inputField: messageInputField
    
    // Function to focus the input field
    function focusInput() {
        messageInputField.forceActiveFocus();
    }

    // Command definitions
    property var allCommands: [
        {
            name: "endpoint",
            description: "Set API endpoint URL",
            execute: args => Ai.setEndpoint(args.join(" "))
        },
        {
            name: "key",
            description: "Set API key",
            execute: args => Ai.setKey(args.join(" "))
        },
        {
            name: "model",
            description: "Set model name",
            execute: args => Ai.setModel(args.join(" "))
        },
        {
            name: "preset",
            description: "Use a preset config (ollama, openai, poe, openrouter)",
            execute: args => Ai.usePreset(args[0])
        },
        {
            name: "temp",
            description: "Set temperature (0-2)",
            execute: args => Ai.setTemperature(parseFloat(args[0]))
        },
        {
            name: "system",
            description: "Set system prompt",
            execute: args => Ai.setSystemPrompt(args.join(" "))
        },
        {
            name: "status",
            description: "Show current configuration",
            execute: () => Ai.showStatus()
        },
        {
            name: "clear",
            description: "Clear chat history",
            execute: () => Ai.clearMessages()
        },
        {
            name: "help",
            description: "Show available commands",
            execute: () => Ai.showHelp()
        },
    ]

    function handleInput(inputText) {
        if (inputText.startsWith(root.commandPrefix)) {
            const parts = inputText.split(" ");
            const command = parts[0].substring(1).toLowerCase();
            const args = parts.slice(1);
            const commandObj = root.allCommands.find(cmd => cmd.name === command);

            if (commandObj) {
                commandObj.execute(args);
            } else {
                Ai.addMessage("Unknown command: `" + command + "`\nType `/help` for available commands.", Ai.interfaceRole);
            }
        } else {
            Ai.sendUserMessage(inputText);
        }

        messageListView.positionViewAtEnd();
    }

    Keys.onPressed: event => {
        messageInputField.forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Status bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: Colors.bgSurface
            radius: 10
            border.color: Colors.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 10

                // Model indicator
                Rectangle {
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: modelText.implicitWidth + 20
                    radius: 6
                    color: Colors.bgAccent

                    Text {
                        id: modelText
                        anchors.centerIn: parent
                        text: Ai.displayName
                        color: Colors.textAccent
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        font.family: "monospace"
                    }
                }

                // Status indicator
                Row {
                    spacing: 6

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        anchors.verticalCenter: parent.verticalCenter
                        color: Ai.isReady ? Colors.success : Colors.error

                        // Pulsing animation when ready
                        SequentialAnimation on opacity {
                            running: Ai.isReady
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.5; duration: 1000 }
                            NumberAnimation { to: 1.0; duration: 1000 }
                        }
                    }

                    Text {
                        text: Ai.isReady ? "Ready" : "Setup needed"
                        color: Ai.isReady ? Colors.success : Colors.textMuted
                        font.pixelSize: 13
                        font.family: "Inter, sans-serif"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item { Layout.fillWidth: true }

                // Temperature
                Text {
                    visible: Ai.isReady
                    text: "T:" + Ai.temperature.toFixed(1)
                    color: Colors.textMuted
                    font.pixelSize: 10
                    font.family: "monospace"
                }

                // Token count
                Rectangle {
                    visible: Ai.tokenCount.total > 0
                    Layout.preferredHeight: 22
                    Layout.preferredWidth: tokenText.implicitWidth + 12
                    radius: 4
                    color: Colors.bgSurface

                    Text {
                        id: tokenText
                        anchors.centerIn: parent
                        text: Ai.tokenCount.total + " tok"
                        color: Colors.textMuted
                        font.pixelSize: 9
                        font.family: "monospace"
                    }
                }
            }
        }

        // Message list
        ListView {
            id: messageListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10

            model: Ai.messageIDs

            delegate: AiMessage {
                required property var modelData
                required property int index
                width: messageListView.width
                messageIndex: index
                messageData: Ai.messageByID[modelData]
                visible: messageData?.visibleToUser ?? true
            }

            onContentHeightChanged: {
                if (atYEnd) {
                    Qt.callLater(positionViewAtEnd);
                }
            }

            onCountChanged: {
                console.log("[AiChat] Message count changed:", count);
                Qt.callLater(positionViewAtEnd);
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                
                contentItem: Rectangle {
                    implicitWidth: 6
                    radius: 3
                    color: parent.hovered ? Colors.scrollbarHover : Colors.scrollbar
                    
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }
        }

        // Empty state placeholder
        Item {
            visible: Ai.messageIDs.length === 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: parent.width - 40

                // Icon
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 64
                    height: 64
                    radius: 16
                    color: Colors.bgAccent

                    Text {
                        anchors.centerIn: parent
                        text: "AI"
                        color: Colors.accent
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "monospace"
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "AI Assistant"
                    color: Colors.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    font.family: "Inter, sans-serif"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    text: Ai.isReady ? 
                        "Ready to chat! Type a message below." :
                        "Quick setup:\n\n1. /preset openai  (or poe, ollama)\n2. /key YOUR_API_KEY\n3. Start chatting!"
                    color: Colors.textMuted
                    font.pixelSize: 12
                    font.family: "Inter, sans-serif"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    lineHeight: 1.5
                }

                // Help hint
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: helpText.implicitWidth + 24
                    height: 28
                    radius: 6
                    color: Colors.bgSurface

                    Text {
                        id: helpText
                        anchors.centerIn: parent
                        text: "Type /help for commands"
                        color: Colors.textMuted
                        font.pixelSize: 11
                        font.family: "monospace"
                    }
                }
            }
        }

        // Input area
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(inputLayout.implicitHeight + 20, 56)
            Layout.maximumHeight: 160
            color: Colors.bgSurface
            radius: 12
            border.color: messageInputField.activeFocus ? Colors.borderFocus : Colors.border
            border.width: messageInputField.activeFocus ? 2 : 1

            Behavior on border.color {
                ColorAnimation { duration: 150 }
            }

            Behavior on border.width {
                NumberAnimation { duration: 150 }
            }

            RowLayout {
                id: inputLayout
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    TextArea {
                        id: messageInputField
                        placeholderText: Ai.isReady ? "Type a message..." : "Type /help to get started"
                        placeholderTextColor: Colors.textMuted
                        color: Colors.textPrimary
                        font.pixelSize: 15
                        font.family: "Inter, sans-serif"
                        wrapMode: TextArea.Wrap
                        background: null
                        selectByMouse: true
                        selectionColor: Colors.bgAccent
                        selectedTextColor: Colors.textPrimary

                        Keys.onReturnPressed: event => {
                            if (event.modifiers & Qt.ShiftModifier) {
                                messageInputField.insert(messageInputField.cursorPosition, "\n");
                            } else {
                                const text = messageInputField.text.trim();
                                if (text.length > 0) {
                                    root.handleInput(text);
                                    messageInputField.clear();
                                }
                            }
                            event.accepted = true;
                        }

                        Keys.onTabPressed: event => {
                            event.accepted = true;
                        }
                    }
                }

                // Send button
                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignBottom
                    radius: 10
                    color: sendButtonEnabled ? Colors.accent : Colors.bgSurface
                    
                    property bool sendButtonEnabled: messageInputField.text.trim().length > 0

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    // Send arrow icon
                    Text {
                        anchors.centerIn: parent
                        text: "\u2191"  // Up arrow unicode
                        color: parent.sendButtonEnabled ? Colors.textOnAccent : Colors.textMuted
                        font.pixelSize: 18
                        font.bold: true
                        
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: parent.sendButtonEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (parent.sendButtonEnabled) {
                                const text = messageInputField.text.trim();
                                root.handleInput(text);
                                messageInputField.clear();
                            }
                        }
                    }
                }
            }
        }

        // Quick actions row
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: [
                    { text: "/preset", icon: "\u2699", action: () => { messageInputField.text = "/preset "; messageInputField.forceActiveFocus(); } },
                    { text: "/model", icon: "\u2728", action: () => { messageInputField.text = "/model "; messageInputField.forceActiveFocus(); } },
                    { text: "/help", icon: "?", action: () => Ai.showHelp() },
                    { text: "/clear", icon: "\u2715", action: () => Ai.clearMessages() },
                ]

                Rectangle {
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: buttonContent.implicitWidth + 16
                    radius: 8
                    color: buttonMouse.containsMouse ? Colors.bgSurfaceHover : Colors.bgSurface
                    border.color: buttonMouse.containsMouse ? Colors.borderStrong : "transparent"
                    border.width: 1

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Row {
                        id: buttonContent
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: modelData.text
                            color: buttonMouse.containsMouse ? Colors.textPrimary : Colors.textMuted
                            font.pixelSize: 13
                            font.family: "monospace"
                            
                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }
                        }
                    }

                    MouseArea {
                        id: buttonMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modelData.action()
                    }
                }
            }

            Item { Layout.fillWidth: true }
        }
    }
}
