{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    papirus-icon-theme
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "JetBrainsMono Nerd Font 11";
    terminal = "ghostty";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "";
      display-run = "";
      display-window = "";
      drun-display-format = "{name}";
      window-format = "{w} {t}";
      icon-theme = "Papirus-Dark";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      scroll-method = 0;
      disable-history = false;
      click-to-exit = true;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "@theme" = "~/.cache/matugen/rofi-colors.rasi";

      # Color definitions from matugen
      "*" = {
        bg = mkLiteral "@surface";
        bg-alt = mkLiteral "@surface-container";
        bg-selected = mkLiteral "@primary";
        fg = mkLiteral "@on-surface";
        fg-alt = mkLiteral "@on-surface-variant";
        fg-selected = mkLiteral "@on-primary";
        border = mkLiteral "@outline-variant";
        accent = mkLiteral "@primary";
      };

      window = {
        width = mkLiteral "600px";
        transparency = "real";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@border";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "0";
      };

      mainbox = {
        background-color = mkLiteral "transparent";
        children = map mkLiteral ["inputbar" "message" "listview"];
      };

      # Search bar section
      inputbar = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "12px 12px 0 0";
        padding = mkLiteral "14px 16px";
        spacing = mkLiteral "12px";
        children = map mkLiteral ["prompt" "entry"];
      };

      prompt = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent";
        font = "JetBrainsMono Nerd Font 13";
      };

      entry = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@fg-alt";
        cursor = mkLiteral "text";
      };

      # Results list
      listview = {
        background-color = mkLiteral "transparent";
        columns = 1;
        lines = 8;
        fixed-height = true;
        padding = mkLiteral "8px 0";
        scrollbar = false;
      };

      element = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        padding = mkLiteral "10px 16px";
        spacing = mkLiteral "12px";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };

      "element normal.active" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@bg-selected";
        text-color = mkLiteral "@fg-selected";
        border-radius = mkLiteral "0";
      };

      "element selected.active" = {
        background-color = mkLiteral "@bg-selected";
        text-color = mkLiteral "@fg-selected";
      };

      "element alternate.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };

      element-icon = {
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
        background-color = mkLiteral "transparent";
      };

      element-text = {
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        cursor = mkLiteral "inherit";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
      };

      # Message/error styling
      message = {
        background-color = mkLiteral "transparent";
        border = mkLiteral "0";
      };

      textbox = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-alt";
        padding = mkLiteral "8px 16px";
      };

      error-message = {
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@error";
        padding = mkLiteral "16px";
      };
    };
  };
}
