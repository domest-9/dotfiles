return {
  {
    "savq/melange-nvim",
    priority = 1000,
    enabled = true,
    config = function()
      vim.cmd.colorscheme("melange")
    end,
  },
}
