local function bind(keys, dispatcher, options)
	if options then
		hl.bind(keys, dispatcher, options)
	else
		hl.bind(keys, dispatcher)
	end
end

return function(machine)
	bind("SUPER + Q", hl.dsp.window.close())
	bind("SUPER + M", hl.dsp.exit())
	bind("SUPER + Y", hl.dsp.exec_cmd("hyprlock"))
	bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
	bind("SUPER + O", hl.dsp.exec_cmd("obsidian"))
	bind("SUPER + F", hl.dsp.exec_cmd("nautilus"))
	bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
	bind("SUPER + S", hl.dsp.exec_cmd("rofi -show drun"))
	bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
	bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
	bind("SUPER + SHIFT + K", hl.dsp.window.move({ workspace = "-1" }))
	bind("SUPER + SHIFT + J", hl.dsp.window.move({ workspace = "+1" }))
	bind("SUPER + P", hl.dsp.exec_cmd([[grim -g "$(slurp -d)" - | wl-copy]]))
	bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
	bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
	bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
	bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
	bind("SUPER + I", hl.dsp.window.float({ action = "toggle" }))
	bind("SUPER + R", hl.dsp.submap("resize"))
	bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })

	for workspace = 1, 10 do
		local key = workspace % 10
		bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }))
		bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
	end

	for _, extra in ipairs(machine.extraBinds) do
		local options = {}
		if extra.locked then
			options.locked = true
		end
		if extra.repeating then
			options.repeating = true
		end

		bind(extra.keys, hl.dsp.exec_cmd(extra.command), next(options) and options or nil)
	end

	hl.define_submap("resize", function()
		bind("L", hl.dsp.window.resize({ x = 15, y = 0, relative = true }), { repeating = true })
		bind("H", hl.dsp.window.resize({ x = -15, y = 0, relative = true }), { repeating = true })
		bind("K", hl.dsp.window.resize({ x = 0, y = -15, relative = true }), { repeating = true })
		bind("J", hl.dsp.window.resize({ x = 0, y = 15, relative = true }), { repeating = true })
		bind("escape", hl.dsp.submap("reset"))
		bind("SUPER + R", hl.dsp.submap("reset"))
	end)
end
