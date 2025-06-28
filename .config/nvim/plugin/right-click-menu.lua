vim.cmd([[
  silent! aunmenu PopUp
  silent! anoremenu PopUp.Inspect <cmd>Inspect<CR>
]])

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })
