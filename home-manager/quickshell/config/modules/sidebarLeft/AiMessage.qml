import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../services"

/**
 * Individual message component for the AI chat.
 * Styled with pywal-generated colors.
 */
Item {
    id: messageItem

    property var messageData
    property int messageIndex: -1
    
    // Computed properties for styling
    readonly property bool isUser: messageData?.role === "user"
    readonly property bool isAssistant: messageData?.role === "assistant"
    readonly property bool isSystem: messageData?.role === "interface" || messageData?.role === "system"

    implicitHeight: messageBubble.height + 12

    // Message bubble - full width, no offset margins
    Rectangle {
        id: messageBubble
        
        anchors.left: parent.left
        anchors.right: parent.right
        
        height: contentColumn.implicitHeight + 24
        
        radius: 12
        
        // Different styling per role
        color: {
            if (isUser) return Colors.userBubble;
            if (isAssistant) return Colors.assistantBubble;
            if (isSystem) return Colors.systemBubble;
            return Colors.bgSurface;
        }
        
        border.color: {
            if (isUser) return Colors.userBubbleBorder;
            if (isAssistant) return Colors.assistantBubbleBorder;
            if (isSystem) return Colors.systemBubbleBorder;
            return Colors.border;
        }
        border.width: 1
        
        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Header row with role label and actions
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // Role badge
                Rectangle {
                    Layout.preferredHeight: 22
                    Layout.preferredWidth: roleBadgeText.implicitWidth + 14
                    radius: 4
                    color: {
                        if (isUser) return Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.15);
                        if (isAssistant) return Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.2);
                        if (isSystem) return Qt.rgba(Colors.warning.r, Colors.warning.g, Colors.warning.b, 0.2);
                        return "transparent";
                    }

                    Text {
                        id: roleBadgeText
                        anchors.centerIn: parent
                        text: {
                            if (isUser) return "You";
                            if (isAssistant) return "AI";
                            if (isSystem) return "System";
                            return "";
                        }
                        color: {
                            if (isUser) return Colors.accentBright;
                            if (isAssistant) return Colors.accentBright;
                            if (isSystem) return Colors.warningBright;
                            return Colors.textMuted;
                        }
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        font.family: "monospace"
                    }
                }

                // Model name for assistant
                Text {
                    visible: isAssistant && messageData?.model
                    text: messageData?.model ?? ""
                    color: Colors.textMuted
                    font.pixelSize: 11
                    font.family: "monospace"
                    opacity: 0.7
                }

                Item { Layout.fillWidth: true }

                // Regenerate button for completed assistant messages
                Rectangle {
                    visible: isAssistant && (messageData?.done ?? false)
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 24
                    radius: 4
                    color: regenMouse.containsMouse ? Colors.hoverOverlay : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Regen"
                        color: regenMouse.containsMouse ? Colors.textPrimary : Colors.textMuted
                        font.pixelSize: 11
                        font.family: "Inter, sans-serif"

                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }
                    }

                    MouseArea {
                        id: regenMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (messageIndex >= 0) {
                                Ai.regenerate(messageIndex);
                            }
                        }
                    }
                }
            }

            // Message content - using TextEdit for selection support
            TextEdit {
                id: messageContent
                Layout.fillWidth: true
                text: messageData?.content ?? ""
                color: Colors.textPrimary
                font.pixelSize: 15
                font.family: "Inter, sans-serif"
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.MarkdownText
                readOnly: true
                selectByMouse: true
                selectionColor: Colors.bgAccent
                selectedTextColor: Colors.textPrimary
                
                onLinkActivated: link => Qt.openUrlExternally(link)
            }

            // Thinking/loading indicator
            Row {
                visible: messageData?.thinking ?? false
                spacing: 6
                Layout.topMargin: 4

                Repeater {
                    model: 3
                    
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: Colors.accent

                        SequentialAnimation on opacity {
                            running: messageData?.thinking ?? false
                            loops: Animation.Infinite
                            PauseAnimation { duration: index * 200 }
                            NumberAnimation { to: 0.3; duration: 400; easing.type: Easing.InOutQuad }
                            NumberAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                            PauseAnimation { duration: (2 - index) * 200 }
                        }
                    }
                }
                
                Text {
                    text: "Thinking..."
                    color: Colors.textMuted
                    font.pixelSize: 12
                    font.italic: true
                    font.family: "Inter, sans-serif"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
    
    // Entry animation
    opacity: 0
    Component.onCompleted: {
        opacity = 1;
    }
    
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }
}
