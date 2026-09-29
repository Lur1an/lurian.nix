import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: theme

    property var colors: ({})
    readonly property color surface: colors.surface || "#141318"
    readonly property color container: colors.container || "#211f26"
    readonly property color text: colors.text || "#e7e0eb"
    readonly property color muted: colors.muted || "#cbc3d0"
    readonly property color primary: colors.primary || "#d0bcff"
    readonly property color onPrimary: colors.onPrimary || "#381e72"
    readonly property color outline: colors.outline || "#49454f"
    readonly property color error: colors.error || "#ffb4ab"
    readonly property string font: "JetBrainsMono Nerd Font"

    FileView {
        id: settings
        path: Qt.resolvedUrl("../theme-settings.json")
        blockLoading: true
    }

    FileView {
        path: JSON.parse(settings.text()).palettePath
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            try {
                const next = JSON.parse(text());
                // Retain the last valid palette during partial writes.
                const keys = ["surface", "container", "text", "muted", "primary", "onPrimary", "outline", "error"];
                if (keys.every(key => /^#[0-9a-fA-F]{6}$/.test(next[key])))
                    theme.colors = next;
            } catch (error) {
                console.warn("Waiting for a valid wallpaper palette:", error);
            }
        }
    }
}
