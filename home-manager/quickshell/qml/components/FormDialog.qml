import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: window
    required property var controller
    required property var palette
    readonly property bool busy: controller.state === "submitted" || controller.state === "running"
    title: "Form: " + (controller.definition.title || "Input")
    implicitWidth: 520
    implicitHeight: Math.min(700, content.implicitHeight + 56)
    minimumSize: Qt.size(implicitWidth, implicitHeight)
    maximumSize: Qt.size(implicitWidth, implicitHeight)
    color: palette.surface
    onClosed: controller.dismiss()

    Shortcut { sequence: "Escape"; onActivated: window.controller.dismiss() }

    component FormButton: Button {
        id: button
        property bool primary: false
        implicitHeight: 42
        horizontalPadding: 20
        opacity: enabled ? 1 : 0.55
        contentItem: Text {
            text: button.text
            color: button.primary ? window.palette.onPrimary : window.palette.text
            font.family: window.palette.font
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 8
            color: button.primary ? window.palette.primary : (button.hovered ? window.palette.outline : window.palette.container)
            opacity: button.down ? 0.8 : 1
            border.width: button.activeFocus ? 2 : 0
            border.color: window.palette.primary
        }
    }

    Rectangle {
        anchors.fill: parent
        color: window.palette.surface
        radius: 14
        border.color: window.palette.outline
    }

    ScrollView {
        anchors.fill: parent
        id: scroll
        anchors.margins: 28
        contentWidth: availableWidth
        ColumnLayout {
            id: content
            width: scroll.availableWidth
            spacing: 18
            Label {
                text: window.controller.definition.title || "Input"
                color: window.palette.primary
                font.family: window.palette.font
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }
            Label {
                text: window.controller.definition.description || ""
                visible: text !== ""
                color: window.palette.muted
                font.family: window.palette.font
                font.pixelSize: 12
                lineHeight: 1.35
                textFormat: Text.PlainText
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }
            Repeater {
                model: window.controller.definition.fields || []
                delegate: ColumnLayout {
                    id: field
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    spacing: 8
                    Label {
                        text: field.modelData.label
                        color: window.palette.muted
                        font.family: window.palette.font
                        font.pixelSize: 12
                    }
                    TextField {
                        id: input
                        visible: field.modelData.type !== "select"
                        enabled: !window.busy
                        Layout.fillWidth: true
                        implicitHeight: 44
                        leftPadding: 14
                        rightPadding: 14
                        font.family: window.palette.font
                        font.pixelSize: 13
                        text: window.controller.values[field.modelData.id] || ""
                        placeholderText: field.modelData.placeholder || ""
                        color: window.palette.text
                        placeholderTextColor: window.palette.muted
                        selectionColor: window.palette.primary
                        onTextEdited: window.controller.values[field.modelData.id] = text
                        onAccepted: window.controller.submit()
                        Component.onCompleted: { if (field.index === 0 && visible) forceActiveFocus(); }
                        selectedTextColor: window.palette.onPrimary
                        background: Rectangle {
                            color: window.palette.container
                            radius: 8
                            border.color: input.activeFocus ? window.palette.primary : window.palette.outline
                        }
                    }
                    ComboBox {
                        id: select
                        visible: field.modelData.type === "select"
                        enabled: !window.busy
                        Layout.fillWidth: true
                        implicitHeight: 44
                        leftPadding: 14
                        rightPadding: 40
                        model: field.modelData.options || []
                        currentIndex: Math.max(0, model.indexOf(window.controller.values[field.modelData.id]))
                        onActivated: window.controller.values[field.modelData.id] = currentText
                        Component.onCompleted: { if (field.index === 0 && visible) forceActiveFocus(); }
                        contentItem: Text {
                            text: select.displayText
                            color: window.palette.text
                            font.family: window.palette.font
                            font.pixelSize: 13
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Text {
                            text: select.popup.visible ? "▴" : "▾"
                            color: window.palette.primary
                            font.pixelSize: 18
                            x: select.width - width - 14
                            y: (select.height - height) / 2
                        }
                        background: Rectangle {
                            color: window.palette.container
                            radius: 8
                            border.color: select.activeFocus || select.popup.visible ? window.palette.primary : window.palette.outline
                        }
                        delegate: ItemDelegate {
                            id: option
                            required property int index
                            required property var modelData
                            width: select.width - 12
                            height: 40
                            highlighted: select.highlightedIndex === index
                            contentItem: Text {
                                text: option.modelData
                                color: option.highlighted ? window.palette.onPrimary : window.palette.text
                                font.family: window.palette.font
                                font.pixelSize: 13
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                radius: 6
                                color: option.highlighted ? window.palette.primary : "transparent"
                            }
                        }
                        popup: Popup {
                            y: select.height + 6
                            width: select.width
                            padding: 6
                            implicitHeight: list.contentHeight + 12
                            popupType: Popup.Item
                            contentItem: ListView {
                                id: list
                                clip: true
                                implicitHeight: contentHeight
                                model: select.popup.visible ? select.delegateModel : null
                                currentIndex: select.highlightedIndex
                                highlightMoveDuration: 0
                            }
                            background: Rectangle {
                                color: window.palette.container
                                radius: 10
                                border.color: window.palette.outline
                            }
                        }
                    }
                }
            }
            Label {
                text: window.controller.error
                visible: text !== ""
                color: window.palette.error
                font.family: window.palette.font
                font.pixelSize: 12
                textFormat: Text.PlainText
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: 6
                spacing: 10
                FormButton { text: window.busy ? "Dismiss" : "Cancel"; onClicked: window.controller.dismiss() }
                FormButton {
                    primary: true
                    text: window.busy ? "Applying…" : (window.controller.definition.submitLabel || "Apply")
                    enabled: !window.busy
                    onClicked: window.controller.submit()
                }
            }
        }
    }
}
