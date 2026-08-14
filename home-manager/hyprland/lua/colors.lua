local path = os.getenv("HOME") .. "/.cache/matugen/hyprland-colors.lua"
local ok, colors = pcall(dofile, path)

if ok and type(colors) == "table" then
	return colors
end

return {
	primary = "rgba(bcc3ffff)",
	outline_variant = "rgba(46464fff)",
	shadow = "rgba(000000ff)",
}
