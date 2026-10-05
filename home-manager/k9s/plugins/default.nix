{pkgs, ...}: {
  home.packages = [pkgs.velero];

  xdg.configFile."k9s/plugins.yaml".source = (pkgs.formats.yaml {}).generate "k9s-plugins.yaml" {
    plugins = (import ./cnpg.nix) // (import ./node.nix {inherit pkgs;}) // (import ./velero.nix {inherit pkgs;});
  };
}
