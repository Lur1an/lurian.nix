local machine = require("machine")

hl.plugin.load(machine.plugin)

require("config")(machine)
require("binds")(machine)
require("rules")(machine)
