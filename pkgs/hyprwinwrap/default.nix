# hyprwinwrap - vendored from hyprwm/hyprland-plugins.
#
# Upstream dropped it in commit 3aa21f2 ("all: drop unmaintained plugins", #663,
# 2026-05-12) together with hyprexpo/hyprscrolling/hyprtrails/xtra-dispatchers.
# Source is pinned to the last commit where it still existed and built:
# eaf18d5 ("all: update for 0.55").
#
# We deliberately do NOT use nixpkgs' `hyprlandPlugins.mkHyprlandPlugin`: that
# helper builds with nixpkgs' own Hyprland stdenv, which can ABI-mismatch the
# Hyprland we actually run (the flake input). Instead we build directly with the
# passed-in Hyprland's stdenv so the plugin always matches the compositor.
# Override `hyprland` (and anything else) from pkgs/default.nix if a future
# Hyprland bump breaks the build.
{
  lib,
  cmake,
  pkg-config,
  hyprland,
}:
hyprland.stdenv.mkDerivation {
  pname = "hyprwinwrap";
  version = "0.1-unstable-2026-05-12";

  src = ./src;

  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [hyprland] ++ hyprland.buildInputs;

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-plugins/tree/main/hyprwinwrap";
    description = "Hyprland version of xwinwrap - put any app as a wallpaper";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
