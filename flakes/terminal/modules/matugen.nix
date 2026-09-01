{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal.matugen;
  render = name: value: ''

    [templates.${builtins.toJSON name}]
    input_path = ${builtins.toJSON value.input_path}
    output_path = ${builtins.toJSON value.output_path}'';
  names = builtins.sort builtins.lessThan (builtins.attrNames cfg.templates);
in {
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.matugen];
    xdg.configFile."matugen/config.toml".text =
      "[config]" + lib.concatMapStrings (name: render name cfg.templates.${name}) names + "\n";
  };
}
