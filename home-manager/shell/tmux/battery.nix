{
  pkgs,
  fg,
  bg,
}: let
  percentage = pkgs.writeShellScript "percentage" (
    if pkgs.stdenv.isDarwin
    then ''
      echo $(pmset -g batt | grep -o "[0-9]\+%" | tr '%' ' ')
    ''
    else ''
      path="/org/freedesktop/UPower/devices/DisplayDevice"
      echo $(${pkgs.upower}/bin/upower -i $path | grep -o "[0-9]\+%" | tr '%' ' ')
    ''
  );
  state = pkgs.writeShellScript "state" (
    if pkgs.stdenv.isDarwin
    then ''
      echo $(pmset -g batt | awk '{print $4}')
    ''
    else ''
      path="/org/freedesktop/UPower/devices/DisplayDevice"
      echo $(${pkgs.upower}/bin/upower -i $path | grep state | awk '{print $2}')
    ''
  );
  icon = pkgs.writeShellScript "icon" ''
    percentage=$(${percentage})
    state=$(${state})
    if [ "$state" == "charging" ] || [ "$state" == "fully-charged" ]; then echo "󰂄"
    elif [ $percentage -ge 75 ]; then echo "󱊣"
    elif [ $percentage -ge 50 ]; then echo "󱊢"
    elif [ $percentage -ge 25 ]; then echo "󱊡"
    elif [ $percentage -ge 0  ]; then echo "󰂎"
    fi
  '';
  color = pkgs.writeShellScript "color" ''
    percentage=$(${percentage})
    state=$(${state})
    if [ "$state" == "charging" ] || [ "$state" == "fully-charged" ]; then echo "green"
    elif [ $percentage -ge 75 ]; then echo "green"
    elif [ $percentage -ge 50 ]; then echo "${fg}"
    elif [ $percentage -ge 30 ]; then echo "yellow"
    elif [ $percentage -ge 0  ]; then echo "red"
    fi
  '';
in "#[fg=#(${color})]#(${icon}) #[fg=${fg}]#(${percentage})%"
