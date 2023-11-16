{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: 
let
  colors = config.colorscheme.colors;
in 
{
  home.packages = with pkgs; [
    rofi-wayland
  ];

  xdg.configFile."rofi/colors.rasi".text = ''
    * {
        main-bg:            #${colors.base00};
        main-fg:            #${colors.base04};
        main-br:            #${colors.base0E};
        select-bg:          #b4befeff;
        select-fg:          #11111bff;
        separatorcolor:     transparent;
        border-color:       transparent;
    }
  '';

  xdg.configFile."rofi/config.rasi".text = ''
    // Config //
    configuration {
      modi:                        "drun";
      show-icons:                  false;
      font:                        "JetBrainsMono Nerd Font 10";
    }

    @theme "~/.config/rofi/colors.rasi"


    // Main //
    window {
      height:                      55%;
      width:                       20%;
      transparency:                "real";
      fullscreen:                  false;
      enabled:                     true;
      cursor:                      "default";
      spacing:                     0px;
      padding:                     0px;
      border:                      2px;
      border-radius:               15px;
      border-color:                @main-br;
      background-color:            transparent;
    }

    mainbox {
      enabled:                     true;
      spacing:                     0px;
      orientation:                 vertical;
      children:                    [ "inputbar" , "listbox" ];
      background-color:            transparent;
      background-image:            url("~/wallpapers/gurren_lagann.jpg", height);
    }


    // Inputs //
    inputbar {
      enabled:                     true;
      padding:                     7px;
      children:                    [ "entry" ];
      background-color:            @main-bg;
    }
    entry {
      enabled:                     true;
      padding:                     70px;
      text-color:                  @main-fg;
      background-color:            @main-bg;
      background-image:            url("~/.config/swww/wall.blur", width);
    }


    // Lists //
    listbox {
      spacing:                     0px;
      padding:                     6px;
      children:                    [ "listview" ];
      background-color:            @main-bg;
    }
    listview {
      enabled:                     true;
      columns:                     1;
      cycle:                       true;
      dynamic:                     true;
      scrollbar:                   false;
      layout:                      vertical;
      reverse:                     false;
      fixed-height:                false;
      fixed-columns:               true;
      cursor:                      "default";
      background-color:            transparent;
      text-color:                  @main-fg;
    }


    // Elements //
    element {
      enabled:                     true;
      spacing:                     0px;
      padding:                     12px;
      border-radius:               10px;
      cursor:                      pointer;
      background-color:            transparent;
      text-color:                  @main-fg;
    }
    @media(max-aspect-ratio: 1.8) {
      element {
        orientation:             vertical;
      }
    }
    element selected.normal {
      background-color:            @select-bg;
      text-color:                  @select-fg;
    }
    element-text {
      vertical-align:              0.0;
      horizontal-align:            0.0;
      cursor:                      inherit;
      background-color:            transparent;
      text-color:                  inherit;
    }
  '';
}
