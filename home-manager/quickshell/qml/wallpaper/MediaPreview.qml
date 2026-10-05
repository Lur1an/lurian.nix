pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtMultimedia

Rectangle {
    id: preview
    required property var entry
    required property var theme
    required property int delayMs
    property var loadedEntry: null

    color: theme.container
    radius: 10
    clip: true

    function schedule() {
        // Destroy the old decoder immediately; late signals cannot affect the
        // next preview because each selection receives its own component.
        loadedEntry = null;
        delay.stop();
        if (entry)
            delay.start();
    }

    onEntryChanged: schedule()
    Component.onCompleted: schedule()

    Timer {
        id: delay
        interval: preview.delayMs
        onTriggered: preview.loadedEntry = preview.entry
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: media
                // The image, GIF and video components share these dynamic properties.
                readonly property var previewItem: item
                anchors.fill: parent
                active: preview.loadedEntry !== null
                sourceComponent: !preview.loadedEntry ? null : preview.loadedEntry.kind === "video" ? videoComponent : preview.loadedEntry.kind === "gif" ? gifComponent : imageComponent
            }

            Text {
                anchors.centerIn: parent
                width: parent.width - 20
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                color: preview.theme.muted
                font.family: preview.theme.font
                font.pixelSize: 12
                text: !preview.entry ? "Choose a wallpaper" : !media.previewItem ? "Loading preview…" : media.previewItem.failed ? "Preview unavailable\nYou can still try applying this wallpaper." : media.previewItem.loading ? "Loading preview…" : ""
            }
        }

        Text {
            Layout.fillWidth: true
            text: preview.entry ? preview.entry.name : ""
            textFormat: Text.PlainText
            elide: Text.ElideMiddle
            color: preview.theme.text
            font.family: preview.theme.font
            font.pixelSize: 13
            font.bold: true
        }
        Text {
            Layout.fillWidth: true
            text: preview.entry ? preview.entry.kind.toUpperCase() + "  ·  " + preview.entry.root : ""
            textFormat: Text.PlainText
            elide: Text.ElideMiddle
            color: preview.theme.muted
            font.family: preview.theme.font
            font.pixelSize: 10
        }
    }

    Component {
        id: imageComponent
        Image {
            source: preview.loadedEntry ? preview.loadedEntry.url : ""
            asynchronous: true
            cache: false
            sourceSize: Qt.size(1200, 900)
            fillMode: Image.PreserveAspectFit
            readonly property bool failed: status === Image.Error
            readonly property bool loading: status === Image.Loading
        }
    }

    Component {
        id: gifComponent
        AnimatedImage {
            source: preview.loadedEntry ? preview.loadedEntry.url : ""
            asynchronous: true
            cache: false
            playing: true
            // GIFs may specify a finite loop count. Keep the preview looping.
            onPlayingChanged: {
                if (!playing && status === Image.Ready)
                    playing = true;
            }
            fillMode: Image.PreserveAspectFit
            readonly property bool failed: status === Image.Error
            readonly property bool loading: status === Image.Loading
        }
    }

    Component {
        id: videoComponent
        Item {
            readonly property bool failed: player.error !== MediaPlayer.NoError
            readonly property bool loading: player.mediaStatus === MediaPlayer.LoadingMedia || player.mediaStatus === MediaPlayer.NoMedia
            MediaPlayer {
                id: player
                source: preview.loadedEntry ? preview.loadedEntry.url : ""
                videoOutput: output
                audioOutput: AudioOutput {
                    muted: true
                    volume: 0
                }
                loops: MediaPlayer.Infinite
                Component.onCompleted: play()
                Component.onDestruction: stop()
            }
            VideoOutput {
                id: output
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
            }
        }
    }
}
