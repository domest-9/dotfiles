-- ~/.config/nvim/lua/config/plugins/snacks/dashboard.lua
return {
  "folke/snacks.nvim",
  enabled = true,
  opts = {
    dashboard = require("config.plugins.snacks.dashboard"),
    -- zen = require("config.plugins.snacks.zen"),
    notifier = require("config.plugins.snacks.notifier"),
  }
}
