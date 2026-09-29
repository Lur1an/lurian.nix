import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ListView {
    id: list

    required property var controller
    required property var palette
    signal chosen

    model: controller.results
    currentIndex: controller.selectedIndex
    clip: true
    spacing: 4
    boundsBehavior: Flickable.StopAtBounds
    onCurrentIndexChanged: {
        if (currentIndex >= 0)
            positionViewAtIndex(currentIndex, ListView.Contain);
    }
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    delegate: Rectangle {
        id: row
        required property var modelData
        required property int index
        readonly property bool selected: index === list.currentIndex

        width: list.width
        height: 66
        radius: 8
        color: selected ? list.palette.primary : (mouse.containsMouse ? list.palette.container : "transparent")

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Text {
                text: row.modelData.kind === "image" ? "IMG" : (row.modelData.kind === "gif" ? "GIF" : "VID")
                color: row.selected ? list.palette.onPrimary : list.palette.primary
                font.family: list.palette.font
                font.pixelSize: 10
                font.bold: true
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text {
                    Layout.fillWidth: true
                    text: row.modelData.name
                    textFormat: Text.PlainText
                    elide: Text.ElideMiddle
                    color: row.selected ? list.palette.onPrimary : list.palette.text
                    font.family: list.palette.font
                    font.pixelSize: 13
                }
                Text {
                    Layout.fillWidth: true
                    text: row.modelData.relativePath
                    textFormat: Text.PlainText
                    elide: Text.ElideMiddle
                    color: row.selected ? list.palette.onPrimary : list.palette.muted
                    opacity: 0.75
                    font.family: list.palette.font
                    font.pixelSize: 10
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                list.controller.selectedIndex = row.index;
                list.chosen();
            }
            onDoubleClicked: {
                list.controller.selectedIndex = row.index;
                list.controller.apply();
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: list.count === 0
        text: list.controller.scanning ? "Finding wallpapers…" : "No matching wallpapers"
        color: list.palette.muted
        font.family: list.palette.font
        font.pixelSize: 12
    }
}
