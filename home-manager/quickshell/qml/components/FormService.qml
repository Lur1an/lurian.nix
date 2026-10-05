pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service
    required property var palette
    property string requestId: ""
    property var definition: ({})
    property var values: ({})
    property string state: "missing"
    property string error: ""
    property bool visible: false
    property double heartbeat: 0

    function dismiss() {
        visible = false;
        if (state !== "running") {
            state = "cancelled";
            values = {};
        }
    }

    function submit() {
        for (const field of definition.fields) {
            const value = values[field.id] || "";
            if ((field.required && !value) || (field.pattern && !new RegExp(field.pattern).test(value))) {
                error = field.validationMessage || ("Check " + field.label);
                return;
            }
        }
        error = "";
        state = "submitted";
    }

    IpcHandler {
        target: "forms"
        function ping(): string { return "ready"; }
        function open(id: string, json: string): string {
            if (service.requestId) return "busy";
            try {
                const form = JSON.parse(json);
                if (!Array.isArray(form.fields) || !form.fields.length) return "invalid";
                const values = {};
                for (const field of form.fields) {
                    if (!field.id || !field.label || (field.type && !["text", "select"].includes(field.type))) return "invalid";
                    if (field.type === "select" && (!Array.isArray(field.options) || !field.options.length)) return "invalid";
                    if (field.pattern) new RegExp(field.pattern);
                    values[field.id] = field.value || (field.type === "select" ? field.options[0] : "");
                }
                service.definition = form;
                service.values = values;
                service.error = "";
                service.requestId = id;
                service.state = "editing";
                service.heartbeat = Date.now();
                service.visible = true;
                return "ok";
            } catch (e) { return "invalid"; }
        }
        function poll(id: string): string {
            if (id !== service.requestId) return JSON.stringify({state: "missing"});
            service.heartbeat = Date.now();
            const result = {state: service.state};
            if (service.state === "submitted") {
                result.values = service.values;
                service.state = "running";
            }
            return JSON.stringify(result);
        }
        function finish(id: string, error: string): string {
            if (id !== service.requestId || !service.visible) return "dismissed";
            if (error) {
                service.error = error;
                service.state = "editing";
            } else {
                service.visible = false;
                service.state = "done";
            }
            return "ok";
        }
        function release(id: string): void {
            if (id !== service.requestId) return;
            service.visible = false;
            service.requestId = "";
            service.values = {};
            service.definition = {};
            service.state = "missing";
        }
    }

    Timer {
        interval: 1000
        running: service.requestId !== ""
        repeat: true
        onTriggered: {
            if (Date.now() - service.heartbeat > 15000) {
                service.visible = false;
                service.requestId = "";
                service.values = {};
                service.state = "missing";
            }
        }
    }

    LazyLoader {
        active: service.visible
        component: FormDialog { controller: service; palette: service.palette }
    }
}
