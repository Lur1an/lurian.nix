# Vendored from hyprwm/hyprland-plugins; see README.md for provenance.
{
  lib,
  cmake,
  pkg-config,
  hyprland,
}:
hyprland.stdenv.mkDerivation {
  pname = "hyprwinwrap";
  version = "0.1-unstable-2026-10-20";

  src = ./src;

  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [hyprland] ++ hyprland.buildInputs;

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-plugins";
    description = "Hyprland version of xwinwrap - put any app as a wallpaper";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
