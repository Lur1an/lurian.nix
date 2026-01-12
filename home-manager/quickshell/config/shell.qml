import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "services"
import "modules/sidebarLeft"

ShellRoot {
    id: root

    // Global state for sidebar visibility
    property bool sidebarVisible: false
    
    // Track which monitor the sidebar was opened on (sticky)
    property string sidebarMonitor: ""

    // IPC handler for external commands (use: qs ipc call sidebar toggle)
    IpcHandler {
        target: "sidebar"

        function toggle(): void {
            if (root.sidebarVisible) {
                // Closing - clear the monitor
                root.sidebarVisible = false;
                root.sidebarMonitor = "";
            } else {
                // Opening - capture current focused monitor
                root.sidebarMonitor = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
                root.sidebarVisible = true;
            }
        }

        function show(): void {
            if (!root.sidebarVisible) {
                root.sidebarMonitor = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
                root.sidebarVisible = true;
            }
        }

        function hide(): void {
            root.sidebarVisible = false;
            root.sidebarMonitor = "";
        }

        function isVisible(): bool {
            return root.sidebarVisible;
        }
    }

    // Create sidebar for each screen, but only show on the monitor where it was opened
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: sidebarPanel
            required property var modelData
            screen: modelData

            // Check if this screen is where the sidebar should be shown
            readonly property bool isTargetScreen: root.sidebarMonitor === modelData.name

            anchors {
                top: true
                bottom: true
                left: true
            }

            // Only show on the target screen when sidebar is visible
            implicitWidth: (root.sidebarVisible && isTargetScreen) ? 480 : 0
            visible: root.sidebarVisible && isTargetScreen

            WlrLayershell.layer: WlrLayershell.Overlay
            WlrLayershell.namespace: "quickshell-sidebar"
            WlrLayershell.keyboardFocus: WlrLayershell.OnDemand

            color: "transparent"

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            SidebarLeft {
                anchors.fill: parent
                anchors.margins: 8
                visible: root.sidebarVisible && sidebarPanel.isTargetScreen
                opacity: (root.sidebarVisible && sidebarPanel.isTargetScreen) ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }
        }
    }
}
