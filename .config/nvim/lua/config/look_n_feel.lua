-- Sets background to not interfere with kitty opasity
-- 	Aka removes background in nvim
vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
]]

-- vim.cmd [[hi @function.builtin.lua guifg=purple]]
-- vim.cmd [[hi @keyword guifg=black]]

-- creates a scrippt for marking the section that is yanked
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('Kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- relative numbers for neovim
vim.opt.number = true
vim.opt.relativenumber = true

-- Things for the neovim terminal, appearence
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custum-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})


-- Tab characteristics
vim.opt.shiftwidth = 4

-- clipboard setting
vim.opt.clipboard = "unnamedplus"
