local colors = require("colors")

return function(machine)
	hl.env("WLR_DRM_NO_ATOMIC", "1")
	hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
	hl.env("ELECTRON_ENABLE_WAYLAND", "1")

	for _, monitor in ipairs(machine.monitors) do
		hl.monitor(monitor)
	end

	hl.config({
		xwayland = {
			force_zero_scaling = true,
		},
		input = {
			kb_options = "caps:escape,compose:ralt",
			touchpad = {
				natural_scroll = true,
				disable_while_typing = true,
				drag_lock = true,
			},
		},
		cursor = {
			no_hardware_cursors = 1,
			use_cpu_buffer = 1,
			inactive_timeout = 3,
		},
		general = {
			gaps_in = 6,
			gaps_out = 10,
			border_size = 2,
			layout = "dwindle",
			col = {
				active_border = colors.primary,
				inactive_border = colors.outline_variant,
			},
		},
		decoration = {
			rounding = 10,
			dim_inactive = false,
			shadow = {
				enabled = true,
				color = colors.shadow,
				range = 30,
				offset = { 0, 2 },
				render_power = 4,
			},
			blur = {
				enabled = true,
				size = 4,
				passes = 2,
				new_optimizations = false,
				noise = 0.01,
				contrast = 0.9,
				brightness = 0.8,
				xray = false,
				popups = true,
			},
		},
		animations = {
			enabled = true,
		},
		misc = {
			disable_splash_rendering = true,
			force_default_wallpaper = 1,
		},
	})

	if machine.plugin then
		hl.config({
			plugin = {
				hyprwinwrap = {
					class = "mpv",
				},
			},
		})
	end

	if next(machine.configOverrides) ~= nil then
		hl.config(machine.configOverrides)
	end

	hl.curve("myBezier", {
		type = "bezier",
		points = {
			{ 0.05, 0.9 },
			{ 0.1, 1.05 },
		},
	})
	hl.curve("overshot", {
		type = "bezier",
		points = {
			{ 0.13, 0.99 },
			{ 0.29, 1.1 },
		},
	})

	hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
	hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
	hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
	hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
	hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slidefade 20%" })

	hl.on("hyprland.start", function()
		hl.exec_cmd(machine.sessionStartupCommand)
		hl.exec_cmd("hyprctl setcursor Qogir 24")
		hl.exec_cmd("telegram-desktop")
		hl.exec_cmd("firefox")
		hl.exec_cmd("pywalfox start")

		for _, command in ipairs(machine.startupCommands) do
			hl.exec_cmd(command)
		end
	end)

	hl.on("hyprland.shutdown", function()
		os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
	end)
end
