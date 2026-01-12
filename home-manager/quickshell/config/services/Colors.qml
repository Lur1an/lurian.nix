pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Color palette singleton that loads pywal-generated colors.
 * Reads from ~/.cache/wal/colors.json and provides semantic color aliases.
 */
Singleton {
    id: root

    // Path to wal colors file
    readonly property string walColorsPath: Quickshell.env("HOME") + "/.cache/wal/colors.json"
    
    // Raw color values from wal (with fallbacks)
    property color background: "#0b0710"
    property color foreground: "#cfb2dc"
    property color cursor: "#cfb2dc"
    
    property color color0: "#0b0710"
    property color color1: "#573A68"
    property color color2: "#654477"
    property color color3: "#81687E"
    property color color4: "#74388A"
    property color color5: "#745089"
    property color color6: "#9065A8"
    property color color7: "#cfb2dc"
    property color color8: "#907c9a"
    property color color9: "#573A68"
    property color color10: "#654477"
    property color color11: "#81687E"
    property color color12: "#74388A"
    property color color13: "#745089"
    property color color14: "#9065A8"
    property color color15: "#cfb2dc"
    
    // =========================================
    // Semantic color aliases for UI components
    // =========================================
    
    // Backgrounds
    readonly property color bgPrimary: background
    readonly property color bgSecondary: color0
    readonly property color bgTertiary: color8
    readonly property color bgSurface: Qt.rgba(color8.r, color8.g, color8.b, 0.15)
    readonly property color bgSurfaceHover: Qt.rgba(color8.r, color8.g, color8.b, 0.25)
    readonly property color bgAccent: Qt.rgba(color4.r, color4.g, color4.b, 0.2)
    readonly property color bgAccentHover: Qt.rgba(color4.r, color4.g, color4.b, 0.35)
    
    // Text
    readonly property color textPrimary: foreground
    readonly property color textSecondary: color7
    readonly property color textMuted: color8
    readonly property color textAccent: color12
    readonly property color textOnAccent: background
    
    // Accent colors
    readonly property color accent: color4
    readonly property color accentBright: color12
    readonly property color accentDim: Qt.rgba(color4.r, color4.g, color4.b, 0.6)
    
    // Status colors
    readonly property color success: color2
    readonly property color successBright: color10
    readonly property color warning: color3
    readonly property color warningBright: color11
    readonly property color error: color1
    readonly property color errorBright: color9
    readonly property color info: color6
    readonly property color infoBright: color14
    
    // Borders
    readonly property color border: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.12)
    readonly property color borderStrong: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.25)
    readonly property color borderAccent: Qt.rgba(color4.r, color4.g, color4.b, 0.5)
    readonly property color borderFocus: Qt.rgba(color12.r, color12.g, color12.b, 0.6)
    
    // Message bubbles
    readonly property color userBubble: Qt.rgba(color4.r, color4.g, color4.b, 0.2)
    readonly property color userBubbleBorder: Qt.rgba(color4.r, color4.g, color4.b, 0.35)
    readonly property color assistantBubble: Qt.rgba(color8.r, color8.g, color8.b, 0.2)
    readonly property color assistantBubbleBorder: Qt.rgba(color8.r, color8.g, color8.b, 0.3)
    readonly property color systemBubble: Qt.rgba(color3.r, color3.g, color3.b, 0.15)
    readonly property color systemBubbleBorder: Qt.rgba(color3.r, color3.g, color3.b, 0.3)
    
    // Interactive states
    readonly property color hoverOverlay: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.06)
    readonly property color pressedOverlay: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.12)
    readonly property color focusRing: Qt.rgba(color12.r, color12.g, color12.b, 0.5)
    
    // Scrollbar
    readonly property color scrollbar: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.15)
    readonly property color scrollbarHover: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.3)
    
    // Shadow
    readonly property color shadow: Qt.rgba(0, 0, 0, 0.4)
    readonly property color shadowLight: Qt.rgba(0, 0, 0, 0.2)
    
    // Process to load colors file
    property var colorLoader: Process {
        id: colorLoaderProcess
        command: ["cat", root.walColorsPath]
        stdout: SplitParser {
            splitMarker: ""  // Read all at once
            onRead: data => {
                root.parseColors(data);
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.warn("[Colors] Failed to load wal colors file, using defaults");
            }
        }
    }
    
    function loadColors(): void {
        colorLoaderProcess.running = true;
    }
    
    function parseColors(jsonText: string): void {
        try {
            const data = JSON.parse(jsonText);
            
            // Parse special colors
            if (data.special) {
                root.background = data.special.background || root.background;
                root.foreground = data.special.foreground || root.foreground;
                root.cursor = data.special.cursor || root.cursor;
            }
            
            // Parse color palette
            if (data.colors) {
                root.color0 = data.colors.color0 || root.color0;
                root.color1 = data.colors.color1 || root.color1;
                root.color2 = data.colors.color2 || root.color2;
                root.color3 = data.colors.color3 || root.color3;
                root.color4 = data.colors.color4 || root.color4;
                root.color5 = data.colors.color5 || root.color5;
                root.color6 = data.colors.color6 || root.color6;
                root.color7 = data.colors.color7 || root.color7;
                root.color8 = data.colors.color8 || root.color8;
                root.color9 = data.colors.color9 || root.color9;
                root.color10 = data.colors.color10 || root.color10;
                root.color11 = data.colors.color11 || root.color11;
                root.color12 = data.colors.color12 || root.color12;
                root.color13 = data.colors.color13 || root.color13;
                root.color14 = data.colors.color14 || root.color14;
                root.color15 = data.colors.color15 || root.color15;
            }
            
            console.log("[Colors] Loaded wal colors - accent:", root.color4);
        } catch (e) {
            console.warn("[Colors] Failed to parse wal colors:", e);
        }
    }
    
    Component.onCompleted: {
        console.log("[Colors] Initialized, loading from:", walColorsPath);
        loadColors();
    }
}
