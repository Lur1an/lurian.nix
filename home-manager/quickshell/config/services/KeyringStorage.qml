pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Secure storage for API keys using the system keyring.
 * Uses secret-tool (libsecret) to store/retrieve keys.
 */
Singleton {
    id: root

    property bool loaded: false
    property var keyringData: ({})

    property var properties: ({
        "application": "quickshell-ai",
        "explanation": "For storing API keys and sensitive data",
    })

    property string keyringLabel: "Quickshell AI Keys"

    function setNestedField(path, value) {
        if (!root.keyringData) root.keyringData = {};
        let keys = path;
        let obj = root.keyringData;
        let parents = [obj];

        // Traverse and collect parent objects
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        // Set the value at the innermost key
        obj[keys[keys.length - 1]] = value;

        // Reassign each parent object from the bottom up to trigger change notifications
        for (let i = keys.length - 2; i >= 0; --i) {
            let parent = parents[i];
            let key = keys[i];
            parent[key] = Object.assign({}, parent[key]);
        }

        // Trigger top-level change
        root.keyringData = Object.assign({}, root.keyringData);

        saveKeyringData();
    }

    function fetchKeyringData() {
        getData.running = true;
    }

    function saveKeyringData() {
        saveData.stdinEnabled = true;
        saveData.running = true;
    }

    Process {
        id: saveData
        command: [
            "secret-tool", "store",
            "--label=" + root.keyringLabel,
            "application", root.properties.application,
        ]
        onRunningChanged: {
            if (saveData.running) {
                saveData.write(JSON.stringify(root.keyringData));
                stdinEnabled = false; // Close stdin to signal EOF
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.error("[KeyringStorage] Failed to save keyring data, exit code:", exitCode);
            }
        }
    }

    Process {
        id: getData
        command: [
            "bash", "-c",
            "secret-tool lookup application quickshell-ai 2>/dev/null || echo '{}'"
        ]
        stdout: SplitParser {
            onRead: data => {
                if (data.length === 0) return;
                // Only parse if it looks like JSON
                const trimmed = data.trim();
                if (!trimmed.startsWith("{")) return;

                try {
                    root.keyringData = JSON.parse(trimmed);
                } catch (e) {
                    console.error("[KeyringStorage] Failed to parse keyring data:", e);
                    root.keyringData = {};
                }
            }
        }
        onExited: (exitCode, exitStatus) => {
            root.loaded = true;
            if (exitCode !== 0 && exitCode !== 1) {
                console.error("[KeyringStorage] Failed to fetch keyring data, exit code:", exitCode);
            }
        }
    }

    Component.onCompleted: {
        fetchKeyringData();
    }
}
