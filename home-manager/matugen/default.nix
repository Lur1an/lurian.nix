{
  pkgs,
  config,
  ...
}: let
  configDir = "${config.xdg.configHome}/matugen";
in {
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen/templates".source = ./templates;

  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.k9s]
    input_path = '${configDir}/templates/k9s.yaml'
    output_path = '${config.xdg.configHome}/k9s/skins/matugen.yaml'

    [templates.rofi-colors]
    input_path = '${configDir}/templates/rofi-colors.rasi'
    output_path = '${config.home.homeDirectory}/.cache/matugen/rofi-colors.rasi'

    [templates.hyprland-colors]
    input_path = '${configDir}/templates/hyprland-colors.conf'
    output_path = '${config.home.homeDirectory}/.cache/matugen/hyprland-colors.conf'
  '';
}
