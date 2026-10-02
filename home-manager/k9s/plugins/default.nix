{pkgs, ...}: {
  xdg.configFile."k9s/plugins.yaml".source = (pkgs.formats.yaml {}).generate "k9s-plugins.yaml" {
    plugins = import ./cnpg.nix;
  };
}
