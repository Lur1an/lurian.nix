import QtQuick
import Quickshell
import Quickshell.Io
import "components"
import "wallpaper"

ShellRoot {
    id: shell

    Component.onCompleted: {
        Qt.application.desktopFileName = "lurian-quickshell";
        // Palette updates are handled by FileView, not shell reloads.
        Quickshell.watchFiles = false;
    }

    FileView {
        id: settingsFile
        path: Qt.resolvedUrl("picker-settings.json")
        blockLoading: true
    }

    Theme {
        id: theme
    }

    WallpaperController {
        id: wallpaperController
        settings: JSON.parse(settingsFile.text())
    }

    IpcHandler {
        target: "wallpaperPicker"
        function ping(): string {
            return "ready";
        }
        function toggle(): void {
            wallpaperController.toggle();
        }
    }

    LazyLoader {
        active: wallpaperController.open
        component: WallpaperPicker {
            controller: wallpaperController
            palette: theme
        }
    }
}
