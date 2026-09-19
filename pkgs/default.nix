# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandPlugins = pkgs.hyprlandPlugins.override {inherit hyprland;};
  pkgsWithRust = import inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    overlays = [inputs.rust-overlay.overlays.default];
  };
  verusRustToolchain = pkgsWithRust.rust-bin.stable."1.98.1".default.override {
    extensions = [
      "llvm-tools-preview"
      "rustc-dev"
    ];
  };
  verusRustPlatform = pkgsWithRust.makeRustPlatform {
    cargo = verusRustToolchain;
    rustc = verusRustToolchain;
  };
  vulpineos = pkgs.callPackage ./vulpine {};
in {
  inherit vulpineos;

  chatgpt = pkgs.callPackage ./chatgpt {};
  opencode = pkgs.callPackage ./opencode.nix {};
  opencode2 = pkgs.callPackage ./opencode2.nix {};
  verus = pkgs.callPackage ./verus.nix {
    rustPlatform = verusRustPlatform;
    rustToolchain = verusRustToolchain;
  };
  vulpineos-image = pkgs.callPackage ./vulpine/image.nix {inherit vulpineos;};

  hyprwinwrap = pkgs.callPackage "${inputs.hyprwinwrap}/default.nix" {
    inherit hyprland hyprlandPlugins;
  };
}
