import json
import os
import subprocess
import sys
import tempfile


def main():
    if sys.argv[1] == "--apply":
        mode, context, node = sys.argv[2:5]
        values = json.load(sys.stdin)
        key = values["key"]
        if not key or key.startswith("-") or any(c in key for c in "=:\n\r\t "):
            sys.exit("Invalid label/taint key")
        spec = key + "=" + values.get("value", "")
        if mode == "taint":
            effect = values["effect"]
            if effect not in ("NoSchedule", "PreferNoSchedule", "NoExecute"):
                sys.exit("Invalid taint effect")
            spec += ":" + effect
        return subprocess.run(
            [os.environ["KUBECTL"], "--context", context, mode, "node", node, spec],
            check=False,
        ).returncode

    mode, context, node, kubeconfig = sys.argv[1:5]
    # Preserve K9s's selected config; kubectl also supports KUBECONFIG path lists.
    if kubeconfig and kubeconfig != "$KUBECONFIG":
        os.environ["KUBECONFIG"] = kubeconfig
    fields = [
        {
            "id": "key",
            "label": "Key",
            "required": True,
            "pattern": r"^[^-=:\s][^=:\s]*$",
            "placeholder": "example.com/key",
        },
        {"id": "value", "label": "Value", "placeholder": "Optional"},
    ]
    if mode == "taint":
        fields.append(
            {
                "id": "effect",
                "label": "Effect",
                "type": "select",
                "options": ["NoSchedule", "PreferNoSchedule", "NoExecute"],
            }
        )
    form = {
        "title": f"Add node {mode}",
        "description": f"Node: {node}\nContext: {context}",
        "fields": fields,
        "submitLabel": "Apply",
    }
    with tempfile.NamedTemporaryFile(mode="w", suffix=".json") as source:
        json.dump(form, source)
        source.flush()
        return subprocess.run(
            [
                "quickshell-form",
                source.name,
                sys.executable,
                __file__,
                "--apply",
                mode,
                context,
                node,
            ],
            check=False,
        ).returncode


if __name__ == "__main__":
    sys.exit(main())
