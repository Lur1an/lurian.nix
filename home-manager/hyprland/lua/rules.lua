local floatingClasses = {
	"org.gnome.Calculator",
	"pavucontrol",
	"nm-connection-editor",
	"blueberry.py",
	"org.gnome.Settings",
	"org.gnome.design.Palette",
	"Color Picker",
	"xdg-desktop-portal",
	"xdg-desktop-portal-gnome",
}

return function(machine)
	hl.workspace_rule({
		workspace = "special:quick-terminal",
		on_created_empty = "ghostty --class=com.mitchellh.ghostty.quick --gtk-single-instance=false",
		animation = "slidevert",
	})

	hl.window_rule({
		match = { class = "^com\\.mitchellh\\.ghostty\\.quick$" },
		workspace = "special:quick-terminal",
		float = true,
		size = "1248 702",
		center = true,
	})

	hl.workspace_rule({
		workspace = "special:quick-files",
		on_created_empty = "nautilus --new-window",
		animation = "slidevert",
	})

	hl.window_rule({
		match = { class = "^org\\.gnome\\.Nautilus$" },
		workspace = "special:quick-files",
		float = true,
		size = "1248 702",
		center = true,
	})

	if machine.wallpaperPickerEnabled then
		hl.window_rule({
			match = { title = "^Wallpaper Picker$" },
			float = true,
			center = true,
		})
	end

	hl.window_rule({
		match = { class = "^(org\\.quickshell|lurian-quickshell)$", title = "^Form: .*" },
		float = true,
		center = true,
	})

	for _, class in ipairs(machine.floatingWindows) do
		table.insert(floatingClasses, class)
	end

	for _, class in ipairs(floatingClasses) do
		hl.window_rule({
			match = { class = "^" .. class .. "$" },
			float = true,
		})
	end

	for _, rule in ipairs(machine.windowRules) do
		hl.window_rule({
			match = { class = rule.class },
			workspace = rule.workspace .. (rule.silent and " silent" or ""),
		})
	end

	for _, rule in ipairs(machine.workspaceRules) do
		hl.workspace_rule(rule)
	end
end
