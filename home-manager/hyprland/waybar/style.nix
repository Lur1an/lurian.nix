
{ config, custom, ... }:
let
  colors = config.colorscheme.colors;
in ''
  * {
      border: none;
      border-radius: 0px;
      font-family: ${custom.font};
      font-size: 12;
      min-height: 0;
  }

  window#waybar {
      background: transparent;
  }

  #cava.left, #cava.right {
      background: #${colors.base01};
      margin: 5px; 
      padding: 8px 16px;
      color: #${colors.base0E};
  }

  #cava.left {
      border-radius: 24px 10px 24px 10px;
  }
  #cava.right {
      border-radius: 10px 24px 10px 24px;
  }

  #workspaces {
      background: #${colors.base01};
      margin: 5px 5px;
      padding: 8px 5px;
      border-radius: 16px;
      color: #${colors.base0E}
  }

  #workspaces button {
      padding: 0px 5px;
      margin: 0px 3px;
      border-radius: 16px;
      color: #${colors.base00};
      background: #${colors.base06};
      transition: all 0.3s ease-in-out;
  }

  #workspaces button.active {
      background-color: #${colors.base0D};
      color: #${colors.base00};
      border-radius: 16px;
      min-width: 50px;
      background-size: 400% 400%;
      transition: all 0.3s ease-in-out;
  }

  #workspaces button:hover {
      background-color: #${colors.base05};
      color: #${colors.base00};
      border-radius: 16px;
      min-width: 50px;
      background-size: 400% 400%;
  }

  #tray, #pulseaudio, #network, #battery, #memory,
  #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward{
      background: #${colors.base01};
      font-weight: bold;
      margin: 5px 0px;
  }
  #tray, #pulseaudio, #network, #battery, #memory {
      color: #${colors.base05};
      border-radius: 10px 24px 10px 24px;
      padding: 0 20px;
      margin-left: 7px;
  }
  #clock {
      color: #${colors.base05};
      background: #${colors.base01};
      border-radius: 0px 0px 0px 40px;
      padding: 10px 10px 15px 25px;
      margin-left: 7px;
      font-weight: bold;
      font-size: 16px;
  }
  #custom-launcher {
      color: #${colors.base0D};
      background: #${colors.base01};
      border-radius: 0px 0px 40px 0px;
      margin: 0px;
      padding: 0px 35px 0px 15px;
      font-size: 28px;
  }

  #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward {
      background: #${colors.base01};
      font-size: 22px;
  }
  #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.foward:hover{
      color: #${colors.base05};
  }
  #custom-playerctl.backward {
      color: #${colors.base0E};
      border-radius: 24px 0px 0px 10px;
      padding-left: 16px;
      margin-left: 7px;
  }
  #custom-playerctl.play {
      color: #${colors.base0D};
      padding: 0 5px;
  }
  #custom-playerctl.foward {
      color: #${colors.base0E};
      border-radius: 0px 10px 24px 0px;
      padding-right: 12px;
      margin-right: 7px
  }
  #custom-playerlabel {
      background: #${colors.base01};
      color: #${colors.base05};
      padding: 0 20px;
      border-radius: 24px 10px 24px 10px;
      margin: 5px 0;
      font-weight: bold;
  }
  #window{
      background: #${colors.base01};
      padding-left: 15px;
      padding-right: 15px;
      border-radius: 16px;
      margin-top: 5px;
      margin-bottom: 5px;
      font-weight: normal;
      font-style: normal;
  }
''
