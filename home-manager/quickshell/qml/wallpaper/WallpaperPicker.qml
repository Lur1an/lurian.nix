import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: window
    required property var controller
    required property var palette

    title: "Wallpaper Picker"
    screen: controller.targetScreen
    implicitWidth: Math.min(960, screen ? screen.width * 0.9 : 960)
    implicitHeight: Math.min(600, screen ? screen.height * 0.85 : 600)
    color: palette.surface
    onClosed: controller.dismiss()
    Component.onCompleted: search.forceActiveFocus()

    Rectangle {
        anchors.fill: parent
        color: window.palette.surface
        radius: 12
        border.width: 1
        border.color: window.palette.outline

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "WALLPAPERS"
                    color: window.palette.primary
                    font.family: window.palette.font
                    font.pixelSize: 12
                    font.bold: true
                    font.letterSpacing: 2
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: window.controller.results.length + " / " + window.controller.entries.length
                    color: window.palette.muted
                    font.family: window.palette.font
                    font.pixelSize: 11
                }
            }

            TextField {
                id: search
                Layout.fillWidth: true
                implicitHeight: 44
                leftPadding: 14
                rightPadding: 14
                text: window.controller.query
                onTextEdited: window.controller.query = text
                placeholderText: "Search wallpapers…"
                color: window.palette.text
                placeholderTextColor: window.palette.muted
                selectionColor: window.palette.primary
                selectedTextColor: window.palette.onPrimary
                font.family: window.palette.font
                font.pixelSize: 14
                background: Rectangle {
                    color: window.palette.container
                    radius: 8
                    border.width: 1
                    border.color: search.activeFocus ? window.palette.primary : window.palette.outline
                }
                Keys.priority: Keys.BeforeItem
                Keys.onPressed: event => {
                    const control = event.modifiers & Qt.ControlModifier;
                    if (event.key === Qt.Key_Down || (control && event.key === Qt.Key_N)) {
                        window.controller.navigate(1);
                    } else if (event.key === Qt.Key_Up || (control && event.key === Qt.Key_P)) {
                        window.controller.navigate(-1);
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        window.controller.apply();
                    } else if (event.key === Qt.Key_Escape) {
                        window.controller.dismiss();
                    } else
                        return;
                    event.accepted = true;
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 16
                SearchResults {
                    Layout.preferredWidth: window.width * 0.38
                    Layout.fillHeight: true
                    controller: window.controller
                    palette: window.palette
                    onChosen: search.forceActiveFocus()
                }
                MediaPreview {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    entry: window.controller.selected
                    palette: window.palette
                    delayMs: window.controller.settings.previewDelayMs
                }
            }

            Text {
                Layout.fillWidth: true
                visible: text.length > 0
                text: window.controller.error || window.controller.scanWarning
                textFormat: Text.PlainText
                color: window.controller.error ? window.palette.error : window.palette.muted
                font.family: window.palette.font
                font.pixelSize: 11
                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: window.controller.applying ? "Applying " + window.controller.applyingName + "…" : "Ctrl+P/N navigate     Enter apply     Esc close"
                textFormat: Text.PlainText
                elide: Text.ElideMiddle
                color: window.controller.applying ? window.palette.primary : window.palette.muted
                font.family: window.palette.font
                font.pixelSize: 11
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: window.controller.dismiss()
    }
}
