# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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
  excalidraw-cli = pkgs.callPackage ./excalidraw-cli.nix {};
  opencode = pkgs.callPackage ./opencode.nix {};
  slack-mcp-server = pkgs.callPackage ./slack-mcp-server.nix {};
  verus = pkgs.callPackage ./verus.nix {
    rustPlatform = verusRustPlatform;
    rustToolchain = verusRustToolchain;
  };
  vulpineos-image = pkgs.callPackage ./vulpine/image.nix {inherit vulpineos;};

  hyprwinwrap = pkgs.callPackage ./hyprwinwrap {
    inherit hyprland;
  };
}
