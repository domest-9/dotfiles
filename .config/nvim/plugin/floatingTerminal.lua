-- Enable truecolor support
vim.o.termguicolors = true

-- Transparent floating windows
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", blend = 10 })

-- Exit terminal mode with Esc Esc
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- State to track the floating terminal
local TerminalState = {
  buf = -1,
  win = -1,
}

-- Create a centered floating window
local function create_floating_terminal(opts)
  opts = opts or {}

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.75)
  local height = math.floor(ui.height * 0.75)
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf
      or vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  -- Blend the background slightly
  vim.api.nvim_win_set_option(win, "winblend", 10)

  return { buf = buf, win = win }
end

-- Toggle the floating terminal
local function toggle_floating_terminal()
  if not vim.api.nvim_win_is_valid(TerminalState.win) then
    TerminalState = create_floating_terminal { buf = TerminalState.buf }

    if vim.bo[TerminalState.buf].buftype ~= "terminal" then
      vim.cmd("terminal")
    end
  else
    vim.api.nvim_win_hide(TerminalState.win)
  end
end

-- Create user command and keymaps
vim.api.nvim_create_user_command("Floaterminal", toggle_floating_terminal, {})
vim.keymap.set({ "n", "t" }, "<M-t>", toggle_floating_terminal, { desc = "Toggle floating terminal" })




-- ./.config/nvim/lua/config/keybinds.lua
