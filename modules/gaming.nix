{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.gaming;
in {
  options.lurian.gaming.enable = lib.mkEnableOption "gaming support";

  config = lib.mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        protontricks.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };

    hardware.xpadneo.enable = true;

    environment.systemPackages = [pkgs.mangohud];
  };
}
