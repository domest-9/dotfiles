local config = {
  width = 60,
  row = nil,
  col = nil,
  pane_gap = 4,
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",

  preset = {
    pick = nil,
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  },

  formats = {
    icon = function(item)
      if item.file and item.icon == "file" or item.icon == "directory" then
        return M.icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = "icon" }
    end,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ":~")
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      if #fname > ctx.width then
        local dir = vim.fn.fnamemodify(fname, ":h")
        local file = vim.fn.fnamemodify(fname, ":t")
        if dir and file then
          file = file:sub(-(ctx.width - #dir - 2))
          fname = dir .. "/…" .. file
        end
      end
      local dir, file = fname:match("^(.*)/(.+)$")
      return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
    end,
  },

  sections = {
    -- { section = "header" },

    -- ✅ Add terminal section here
    {
      section = "terminal",
      -- cmd = "chafa Pictures/Wallpapers/891fd5cf1a9cd00edc73e219f30a1c33.jpg --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
      cmd = "clear && cat ~/.cache/nvim/wallpaper/render.txt",
      height = 17,
      padding = 1,
    },
    --
    { section = "keys",   gap = 1, padding = 1 },
    { section = "startup" },

    -- If you're using panes, wrap them in { pane = N, {section}, ... }
    -- {
    --   pane = 2,
    --   { section = "keys",   gap = 1, padding = 1 },
    --   { section = "startup" },
    -- },
  },

}

return config





























-- -- ~/.config/nvim/lua/config/plugins/snacks/dashboard.lua
-- -- this file provides the dashboard configuration for your main snacks plugin
--
-- local m = {}
--
-- -- date and plugins info
-- local days_short = { "sun", "mon", "tue", "wed", "thu", "fri", "sat" }
-- local months_short = { "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" }
-- local t = os.date("*t")
-- local date_str = string.format("today is %s %02d %s", days_short[t.wday], t.day, months_short[t.month])
--
-- local plugin_count = 0
-- local ok, lazy = pcall(require, "lazy")
-- if ok and lazy.stats then
--   plugin_count = lazy.stats().count or 0
-- end
-- local plugin_str = string.format("%d plugins in total", plugin_count)
--
-- -- centering function
-- local function center_line(str)
--   local win_width = 55 -- adjust to match your dashboard width
--   local str_width = vim.fn.strdisplaywidth(str)
--   local pad = math.floor((win_width - str_width) / 2)
--   return string.rep(" ", pad > 0 and pad or 0) .. str
-- end
--
-- -- create the greeting with square bracket design
-- local dash_date_str = " " .. date_str .. " "
-- local dash_plugin_str = " " .. plugin_str .. " "
--
-- -- calculate the length needed to align the right side
-- local max_len = math.max(string.len(dash_date_str), string.len(dash_plugin_str))
--
-- local greeting_box = {
--   center_line("┌─" .. dash_date_str .. string.rep("─", max_len - string.len(dash_date_str)) .. "─┐"),
--   center_line("└─" .. dash_plugin_str .. string.rep("─", max_len - string.len(dash_plugin_str)) .. "─┘"),
-- }
--
-- -- ascii art header with proper centering
-- local ascii_art = {
--   "                                                      ",
--   "    ▄▄▄██▀▀▀▒█████ ▓██   ██▓ ▄▄▄▄    ▒█████ ▓██   ██▓ ",
--   "      ▒██  ▒██▒  ██▒▒██  ██▒▓█████▄ ▒██▒  ██▒▒██  ██▒ ",
--   "      ░██  ▒██░  ██▒ ▒██ ██░▒██▒ ▄██▒██░  ██▒ ▒██ ██░ ",
--   "   ▓██▄██▓ ▒██   ██░ ░ ▐██▓░▒██░█▀  ▒██   ██░ ░ ▐██▓░ ",
--   "    ▓███▒  ░ ████▓▒░ ░ ██▒▓░░▓█  ▀█▓░ ████▓▒░ ░ ██▒▓░ ",
--   "    ▒▓▒▒░  ░ ▒░▒░▒░   ██▒▒▒ ░▒▓███▀▒░ ▒░▒░▒░   ██▒▒▒  ",
--   "    ▒ ░▒░    ░ ▒ ▒░ ▓██ ░▒░ ▒░▒   ░   ░ ▒ ▒░ ▓██ ░▒░  ",
--   "    ░ ░ ░  ░ ░ ░ ▒  ▒ ▒ ░░   ░    ░ ░ ░ ░ ▒  ▒ ▒ ░░   ",
--   "    ░   ░      ░ ░  ░ ░      ░          ░ ░  ░ ░      ",
--   "                    ░ ░           ░          ░ ░      ",
--   "                                                      ",
-- }
--
-- -- center the ascii art
-- local centered_ascii = {}
-- for _, line in ipairs(ascii_art) do
--   table.insert(centered_ascii, center_line(line))
-- end
--
-- -- combine everything for the header
-- local header_content = {}
--
-- -- add centered ascii art
-- for _, line in ipairs(centered_ascii) do
--   table.insert(header_content, line)
-- end
--
-- -- add some spacing
-- table.insert(header_content, "")
-- table.insert(header_content, "")
--
-- -- add the greeting box
-- for _, line in ipairs(greeting_box) do
--   table.insert(header_content, line)
-- end
--
-- -- dashboard configuration
-- m.dashboard = {
--   enabled = true,
--   sections = {
--     { section = "header" },
--     { section = "keys",   gap = 1, padding = 1 },
--     { section = "startup" },
--   },
--   preset = {
--     header = table.concat(header_content, "\n"),
--     keys = {
--       { icon = "󰈞", key = "f", desc = "find file", action = ":telescope find_files<cr>" },
--       { icon = "", key = "e", desc = "new file", action = ":ene | startinsert<cr>" },
--       { icon = "", key = "r", desc = "recent files", action = ":telescope oldfiles<cr>" },
--       { icon = "󰊄", key = "t", desc = "find text", action = ":telescope live_grep<cr>" },
--       { icon = "", key = "c", desc = "configuration", action = ":lua require('yazi').yazi({}, '~/.config/nvim')<cr>" },
--       { icon = "󰿅", key = "q", desc = "quit neovim", action = ":qa<cr>" },
--     },
--   },
-- }
--
-- return m
--
