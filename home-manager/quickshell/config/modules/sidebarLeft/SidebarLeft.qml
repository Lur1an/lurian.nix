import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "../../services"

/**
 * Left sidebar panel container.
 * Styled with pywal-generated colors.
 */
Rectangle {
    id: sidebar

    color: Qt.rgba(Colors.bgPrimary.r, Colors.bgPrimary.g, Colors.bgPrimary.b, 0.95)
    radius: 16
    border.color: Colors.border
    border.width: 1

    // Subtle gradient overlay for depth
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(Colors.foreground.r, Colors.foreground.g, Colors.foreground.b, 0.03) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Inner glow effect
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: parent.radius - 1
        color: "transparent"
        border.color: Qt.rgba(Colors.foreground.r, Colors.foreground.g, Colors.foreground.b, 0.05)
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Icon container with accent glow
            Rectangle {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                radius: 12
                color: Colors.bgAccent

                // Inner icon
                Rectangle {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    radius: 6
                    color: Colors.accent

                    Text {
                        anchors.centerIn: parent
                        text: "AI"
                        color: Colors.textOnAccent
                        font.pixelSize: 10
                        font.bold: true
                        font.family: "monospace"
                    }
                }
            }

            // Title section
            Column {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "AI Assistant"
                    color: Colors.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    font.family: "Inter, sans-serif"
                }

                Text {
                    text: "Quickshell Widget"
                    color: Colors.textMuted
                    font.pixelSize: 12
                    font.family: "Inter, sans-serif"
                }
            }

            // Close button
            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 8
                color: closeMouse.containsMouse ? 
                    Qt.rgba(Colors.error.r, Colors.error.g, Colors.error.b, 0.2) : 
                    "transparent"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    anchors.centerIn: parent
                    text: "\u2715"  // Unicode X
                    color: closeMouse.containsMouse ? Colors.error : Colors.textMuted
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Close via IPC - shell.qml handles the state
                    }
                }
            }
        }

        // Separator with gradient
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: Colors.border }
                GradientStop { position: 0.8; color: Colors.border }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // AI Chat takes the rest
        AiChat {
            id: aiChat
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    // Function to focus the chat input
    function focusInput() {
        aiChat.focusInput();
    }

    // Focus handling - focus input when sidebar becomes visible
    onVisibleChanged: {
        if (visible) {
            // Small delay to ensure the component is fully ready
            Qt.callLater(focusInput);
        }
    }

    Component.onCompleted: {
        if (visible) {
            Qt.callLater(focusInput);
        }
    }
}
