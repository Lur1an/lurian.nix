import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "Fuzzy.js" as Fuzzy

Scope {
    id: controller

    required property var settings
    property bool open: false
    property var targetScreen: null
    property var entries: []
    property var results: []
    property string query: ""
    property int selectedIndex: -1
    readonly property var selected: results[selectedIndex] || null
    property bool applying: false
    property string applyingName: ""
    property string error: ""
    property string scanWarning: ""
    readonly property bool scanning: scanner.running
    property bool scanCancelled: false
    property bool rescanPending: false

    onQueryChanged: filter(false)

    function filter(preserve) {
        const path = preserve && selected ? selected.path : "";
        const next = Fuzzy.rank(entries, query);
        results = next;
        const index = next.findIndex(entry => entry.path === path);
        selectedIndex = index >= 0 ? index : (next.length ? 0 : -1);
    }

    function navigate(delta) {
        if (!results.length)
            return;
        selectedIndex = (selectedIndex + delta + results.length) % results.length;
    }

    function toggle() {
        if (!settings.enabled)
            return;
        if (open) {
            dismiss();
            return;
        }
        const monitor = Hyprland.focusedMonitor;
        targetScreen = Quickshell.screens.find(screen => monitor && screen.name === monitor.name) || Quickshell.screens[0] || null;
        open = true;
        refresh();
    }

    function dismiss() {
        open = false;
        rescanPending = false;
        if (scanner.running) {
            scanCancelled = true;
            scanner.signal(15);
        }
    }

    function refresh() {
        if (scanner.running) {
            rescanPending = true;
            return;
        }
        scanCancelled = false;
        scanWarning = "";
        scanner.command = [settings.scanCommand].concat(settings.directories);
        scanner.running = true;
    }

    function apply() {
        if (!selected || applying)
            return;
        error = "";
        applyingName = selected.name;
        applying = true;
        applyProcess.command = [settings.applyCommand, selected.path];
        applyProcess.running = true;
    }

    Process {
        id: scanner
        stdout: StdioCollector {
            onStreamFinished: {
                if (controller.scanCancelled || !controller.open)
                    return;
                try {
                    const data = JSON.parse(text);
                    controller.entries = data.entries;
                    controller.scanWarning = data.warnings.join("\n");
                    controller.filter(true);
                } catch (error) {
                    controller.scanWarning = "Could not read the wallpaper library.";
                    console.warn("Wallpaper scan:", error);
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim())
                    console.warn(text.trim());
            }
        }
        onExited: (code, status) => {
            if (!controller.scanCancelled && (code !== 0 || status !== 0))
                controller.scanWarning = "Wallpaper scan failed; check the Quickshell journal.";
            if (controller.open && controller.rescanPending) {
                controller.rescanPending = false;
                Qt.callLater(() => {
                    if (controller.open)
                        controller.refresh();
                });
            }
        }
    }

    // This survives closing/unloading the picker window.
    Process {
        id: applyProcess
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim())
                    console.log(text.trim());
            }
        }
        stderr: StdioCollector {
            id: applyErrors
            onStreamFinished: {
                if (text.trim())
                    console.warn(text.trim());
            }
        }
        onExited: (code, status) => {
            controller.applying = false;
            if (code === 0 && status === 0) {
                const warnings = applyErrors.text.split("\n").filter(line => line.startsWith("vpaper: warning:"));
                if (warnings.length) {
                    controller.error = "Wallpaper applied with warnings:\n" + warnings.map(line => line.replace("vpaper: warning: ", "")).join("\n");
                } else {
                    controller.dismiss();
                }
            } else {
                controller.error = "Could not apply " + controller.applyingName + ". " + (applyErrors.text.trim().split("\n").slice(-1)[0] || "Check the Quickshell journal.");
            }
        }
    }
}
