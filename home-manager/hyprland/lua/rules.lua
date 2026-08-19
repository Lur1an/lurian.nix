local floatingClasses = {
	"org.gnome.Calculator",
	"org.gnome.Nautilus",
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
