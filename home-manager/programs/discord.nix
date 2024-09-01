{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
  ];
  xdg.configFile."Vencord/settings/quickCss.css".text = ''
    @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
  '';
}
