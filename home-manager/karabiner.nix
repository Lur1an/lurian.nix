{...}: let
  swap = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {optional = ["any"];};
    };
    to = [{key_code = to;}];
    conditions = [
      {
        type = "frontmost_application_if";
        bundle_identifiers = ["^com\\.mitchellh\\.ghostty$"];
      }
    ];
  };
in {
  home.file.".config/karabiner/assets/complex_modifications/control-command.json".text = builtins.toJSON {
    title = "Control <-> Command";
    rules = [
      {
        description = "Swap Command and Control while in Ghostty";
        manipulators = [
          (swap "left_command" "left_control")
          (swap "left_control" "left_command")
        ];
      }
    ];
  };
}
