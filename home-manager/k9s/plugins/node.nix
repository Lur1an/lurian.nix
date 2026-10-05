{
  node-label = {
    shortCut = "Shift-L";
    description = "Add node label";
    scopes = ["node"];
    command = "bash";
    background = false;
    args = [
      "-c"
      ''
        set -euo pipefail
        printf 'Label node %s (context: %s)\n' "$2" "$1"
        read -r -p 'Label (key=value, blank to cancel): ' label || exit 0
        [[ -n "$label" ]] || exit 0
        if [[ "$label" != *=* || "$label" == =* || "$label" == -* ]]; then
          printf 'Expected a label in key=value format.\n' >&2
          read -r -p 'Press Enter to return to K9s.' || true
          exit 1
        fi
        kubectl --context "$1" label node "$2" "$label"
      ''
      "node-label"
      "$CONTEXT"
      "$NAME"
    ];
  };

  node-taint = {
    shortCut = "Shift-T";
    description = "Add node taint";
    scopes = ["node"];
    command = "bash";
    confirm = true;
    background = false;
    args = [
      "-c"
      ''
        set -euo pipefail
        printf 'Taint node %s (context: %s)\n' "$2" "$1"
        read -r -p 'Taint (key=value:effect or key:effect, blank to cancel): ' taint || exit 0
        [[ -n "$taint" ]] || exit 0
        if [[ ! "$taint" =~ ^[^=:\ -][^:\ ]*:(NoSchedule|PreferNoSchedule|NoExecute)$ ]]; then
          printf 'Expected key=value:effect or key:effect (NoSchedule, PreferNoSchedule, NoExecute).\n' >&2
          read -r -p 'Press Enter to return to K9s.' || true
          exit 1
        fi
        kubectl --context "$1" taint nodes "$2" "$taint"
      ''
      "node-taint"
      "$CONTEXT"
      "$NAME"
    ];
  };
}
