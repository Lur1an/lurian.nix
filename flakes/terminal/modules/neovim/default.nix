{inputs, ...}: {
  config.terminal.homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.nixvim.homeModules.nixvim];
    config = lib.mkIf config.lurian.terminal.neovim.enable {
      programs.nixvim = {
        enable = true;
        nixpkgs.source = pkgs.path;
        defaultEditor = lib.mkDefault true;
        viAlias = lib.mkDefault true;
        vimAlias = lib.mkDefault true;
      };
    };
  };
}
