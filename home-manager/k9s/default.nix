{
  config,
  lib,
  ...
}: {
  imports = [./plugins];

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = lib.optionalAttrs config.lurian.terminal.matugen.enable {
          skin = "matugen";
        };
        refreshRate = "2s";
        readOnly = true;
        logoless = true;
      };
    };
  };
  xdg.configFile."matugen/templates/k9s.yaml".source =
    lib.mkIf config.lurian.terminal.matugen.enable ./matugen.yaml;
  lurian.terminal.matugen.templates = lib.mkIf config.lurian.terminal.matugen.enable {
    k9s = {
      input_path = "${config.xdg.configHome}/matugen/templates/k9s.yaml";
      output_path = "${config.xdg.configHome}/k9s/skins/matugen.yaml";
    };
  };
}
