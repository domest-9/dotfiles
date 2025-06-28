-- Make keys for running lua scripts
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")



-- OTHER KEYMAPS CAN BE FOUND ->
-------------------------------------------------------------------
-- ./.config/nvim/lua/config/telescope/multigrep.lua
-- ./.config/nvim/lua/config/plugins/telescope.lua
-- ./.config/nvim/lua/config/plugins/floaterm.lua
-- ./.config/nvim/plugin/floatingTerminal.lua

-- Make a keybind to open a terminal that runs currently open c++ file
vim.keymap.set("n", "<space>cp", function()
  vim.cmd("w")
  vim.cmd("botright split | terminal bash -c 'g++ -std=c++23 -pedantic -Wall -Wextra % -o output && ./output'")
  vim.cmd("startinsert")
end, { noremap = true, silent = true, desc = "Strict C++ compile and run" })

-- bruh i dont really know, move current errors
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- copy current file path
vim.keymap.set("n", "<space>cfp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy full path to clipboard" })

-- Bind to open a small terminal window
-- Terminal appearence is here ./.config/nvim/lua/config/look_n_feel.lua
local job_id = 0
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)

  job_id = vim.bo.channel
end)

vim.keymap.set("n", "<space>ee", function()
  vim.fn.chansend(job_id, { "ls -al\r\n" })
end)

-- Snacks
-- /home/domest/.config/nvim/lua/config/plugins/snacks/zen.lua
