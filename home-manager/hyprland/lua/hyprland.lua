local machine = require("machine")

if machine.plugin then
	hl.plugin.load(machine.plugin)
end

require("config")(machine)
require("binds")(machine)
require("rules")(machine)
