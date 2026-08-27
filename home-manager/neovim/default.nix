{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./theme.nix
    ./plugins.nix
    ./runtime.nix
    ./keymaps.nix
  ];

  programs.nixvim = {
    enable = true;
    nixpkgs.source = pkgs.path;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
