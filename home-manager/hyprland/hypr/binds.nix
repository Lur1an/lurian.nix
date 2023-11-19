let
  mod = "SUPER";
in [
  "${mod}, Q, killactive"
  "${mod}, M, exit"
  "${mod}, B, exec, firefox"
  "${mod}, T, exec, foot"
  "${mod}, S, exec, rofi -show drun -show-icons"
  "${mod}, M, fakefullscreen"
  "${mod} SHIFT, L, movewindow, r"
  "${mod} SHIFT, H, movewindow, l"
  "${mod} SHIFT, K, movetoworkspace, -1"
  "${mod} SHIFT, J, movetoworkspace, +1"
  ''${mod}, P, exec, mkdir -p ~/Pictures/screenshots; grim -t png -g "$(slurp)" ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%m-%s).png''
  "${mod}, H, movefocus, l"
  "${mod}, L, movefocus, r"
  "${mod}, K, movefocus, u"
  "${mod}, J, movefocus, d"

  "${mod}, R, submap, resize"

  "${mod}, 5, workspace, 5"
  "${mod}, 6, workspace, 6"
  "${mod}, 7, workspace, 7"
  "${mod}, 8, workspace, 8"

  "${mod}, 1, workspace, 1"
  "${mod}, 2, workspace, 2"
  "${mod}, 3, workspace, 3"
  "${mod}, 4, workspace, 4"

  "${mod} SHIFT, 1, movetoworkspacesilent, 1"
  "${mod} SHIFT, 2, movetoworkspacesilent, 2"
  "${mod} SHIFT, 3, movetoworkspacesilent, 3"
  "${mod} SHIFT, 4, movetoworkspacesilent, 4"
  "${mod} SHIFT, 5, movetoworkspacesilent, 5"
  "${mod} SHIFT, 6, movetoworkspacesilent, 6"
  "${mod} SHIFT, 7, movetoworkspacesilent, 7"
  "${mod} SHIFT, 8, movetoworkspacesilent, 8"
]
