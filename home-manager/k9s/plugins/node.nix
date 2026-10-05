{pkgs}: let
  launcher = pkgs.writeShellScript "k9s-node-form" ''
    export KUBECTL=${pkgs.kubectl}/bin/kubectl
    exec ${pkgs.python3}/bin/python3 ${./node_form.py} "$@"
  '';
  action = shortcut: mode: {
    shortCut = shortcut;
    description = "Add node ${mode}";
    scopes = ["node"];
    command = "${launcher}";
    background = true;
    args = [mode "$CONTEXT" "$NAME" "$KUBECONFIG"];
  };
in {
  node-label = action "Shift-L" "label";
  node-taint = action "Shift-T" "taint";
}
