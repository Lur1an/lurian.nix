let
  mod = "SUPER";
in
[
	"${mod}, Q, killactive"
	"${mod}, M, exit"
	"${mod}, B, exec, firefox"
	"${mod}, T, exec, alacritty"
	"${mod}, S, exec, rofi -show drun -show-icons"
	"${mod}, M, fullscreen"
	"${mod} SHIFT, L, movewindow, r"
	"${mod} SHIFT, H, movewindow, l"
	"${mod}, H, movefocus, l"
	"${mod}, L, movefocus, r"
	"${mod}, K, movefocus, u"
	"${mod}, J, movefocus, d"
]
