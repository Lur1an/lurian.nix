{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dracula-icon-theme
  ];
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 10";
    terminal = "ghostty";

    extraConfig = {
      modi = "drun,filebrowser,window,run";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-filebrowser = " ";
      display-window = " ";
      drun-display-format = "{name}";
      window-format = "{w}{t}";
      icon-theme = "Dracula";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "@theme" = "~/.cache/matugen/rofi-colors.rasi";

      "*" = {
        main-bg = mkLiteral "@surface-container";
        main-fg = mkLiteral "@on-surface";
        main-br = mkLiteral "@outline";
        select-bg = mkLiteral "@primary-container";
        select-fg = mkLiteral "@on-primary-container";
      };

      window = {
        height = mkLiteral "30em";
        width = mkLiteral "57em";
        transparency = "real";
        fullscreen = false;
        enabled = true;
        cursor = mkLiteral "default";
        spacing = mkLiteral "0em";
        padding = mkLiteral "0em";
        border-color = mkLiteral "@main-br";
        background-color = mkLiteral "@main-bg";
      };

      mainbox = {
        enabled = true;
        spacing = mkLiteral "1em";
        padding = mkLiteral "1em";
        orientation = mkLiteral "horizontal";
        children = map mkLiteral ["inputbar" "listbox"];
        background-color = mkLiteral "transparent";
      };

      inputbar = {
        enabled = true;
        width = mkLiteral "27em";
        spacing = mkLiteral "0em";
        padding = mkLiteral "0em";
        children = map mkLiteral ["entry"];
        background-color = mkLiteral "transparent";
        background-image = mkLiteral "url(\"~/.config/wallpaper.png\", height)";
        border-radius = mkLiteral "1em";
      };

      entry = {
        enabled = false;
      };

      listbox = {
        spacing = mkLiteral "0em";
        padding = mkLiteral "0em";
        children = map mkLiteral ["dummy" "listview" "dummy"];
        background-color = mkLiteral "transparent";
      };

      listview = {
        enabled = true;
        spacing = mkLiteral "0em";
        padding = mkLiteral "1em";
        columns = 1;
        lines = 7;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        expand = false;
        fixed-height = true;
        fixed-columns = true;
        cursor = mkLiteral "default";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@main-fg";
      };

      dummy = {
        background-color = mkLiteral "transparent";
      };

      element = {
        enabled = true;
        spacing = mkLiteral "1em";
        padding = mkLiteral "0.5em 0.5em 0.5em 1.5em";
        cursor = mkLiteral "pointer";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@main-fg";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@select-bg";
        text-color = mkLiteral "@select-fg";
      };

      element-icon = {
        size = mkLiteral "2.7em";
        cursor = mkLiteral "inherit";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
      };

      element-text = {
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        cursor = mkLiteral "inherit";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
      };

      error-message = {
        text-color = mkLiteral "@main-fg";
        background-color = mkLiteral "@main-bg";
        text-transform = mkLiteral "capitalize";
        children = map mkLiteral ["textbox"];
      };

      textbox = {
        text-color = mkLiteral "inherit";
        background-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };
    };
  };
}
