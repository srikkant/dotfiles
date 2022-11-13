local stdlib = require("lib.std").stdlib

require("config.events")

return stdlib.merge(require("config.base"), require("config.platform"))
