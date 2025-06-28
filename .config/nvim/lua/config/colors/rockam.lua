-- ~/.config/nvim/colors/noir_painterly.lua
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "noir_painterly"

local colors = {
  main_bg  = "#191716", -- darkest bg
  bg0      = "#23201e",
  bg1      = "#2c2927",
  bg2      = "#3a3633",
  bg3      = "#4a4541",
  bg4      = "#5a534e", -- lighter bg for borders, split
  gray     = "#7a736c", -- comments, secondary text
  fg4      = "#b1a99f", -- operators, light gray
  fg3      = "#c2bcb3",
  fg2      = "#d2ccc4", -- strings
  fg1      = "#e0dbd4", -- numbers, constants
  fg0      = "#ede9e3", -- booleans, bright fg
  ochre    = "#bfa97a", -- warm accent 1
  clay     = "#a68c6d", -- warm accent 2
  bone     = "#e7dbc7", -- types
  accent   = "#bfa97a", -- active elements
  accent2  = "#a68c6d", -- secondary accent
  white    = "#f6f3ee",
  black    = "#181716",
  warning  = "#c49a6c",
  critical = "#a65c3a",
  hover_bg = "#3a3633",
}

local set = vim.api.nvim_set_hl

-- Basic editor colors
set(0, "Normal", { fg = colors.fg2, bg = colors.main_bg })
set(0, "NormalNC", { fg = colors.fg3, bg = colors.bg0 })
set(0, "CursorLine", { bg = colors.bg1 })
set(0, "CursorColumn", { bg = colors.bg2 })
set(0, "LineNr", { fg = colors.bg3 })
set(0, "CursorLineNr", { fg = colors.accent, bold = true })

-- Syntax groups
set(0, "Comment", { fg = colors.gray, italic = true })
set(0, "Constant", { fg = colors.white })
set(0, "String", { fg = colors.fg2 })
set(0, "Character", { fg = colors.fg1 })
set(0, "Number", { fg = colors.fg1 })
set(0, "Boolean", { fg = colors.fg0 })
set(0, "Float", { fg = colors.fg1 })

set(0, "Identifier", { fg = colors.ochre })
set(0, "Function", { fg = colors.clay })
set(0, "Statement", { fg = colors.accent, bold = true })
set(0, "Conditional", { fg = colors.accent, bold = true })
set(0, "Repeat", { fg = colors.accent })
set(0, "Label", { fg = colors.accent2 })
set(0, "Keyword", { fg = colors.accent2, bold = true })
set(0, "Exception", { fg = colors.critical, bold = true })

set(0, "PreProc", { fg = colors.clay })
set(0, "Include", { fg = colors.clay })
set(0, "Define", { fg = colors.clay })
set(0, "Macro", { fg = colors.clay })

set(0, "Type", { fg = colors.bone, bold = true })
set(0, "StorageClass", { fg = colors.bone })
set(0, "Structure", { fg = colors.bone })
set(0, "Typedef", { fg = colors.bone })

set(0, "Operator", { fg = colors.fg4 })
set(0, "Title", { fg = colors.accent, bold = true })
set(0, "Special", { fg = colors.accent2 })
set(0, "Todo", { fg = colors.warning, bg = colors.bg2, bold = true })
set(0, "Error", { fg = colors.critical, bold = true })
set(0, "ErrorMsg", { fg = colors.critical, bold = true, bg = colors.bg0 })

-- UI and misc
set(0, "Visual", { bg = colors.hover_bg })
set(0, "Search", { fg = colors.main_bg, bg = colors.accent2, bold = true })
set(0, "IncSearch", { fg = colors.main_bg, bg = colors.accent, bold = true })
set(0, "MatchParen", { fg = colors.bone, bg = colors.bg3, bold = true })

set(0, "Pmenu", { fg = colors.fg3, bg = colors.bg2 })
set(0, "PmenuSel", { fg = colors.main_bg, bg = colors.accent2, bold = true })
set(0, "PmenuSbar", { bg = colors.bg3 })
set(0, "PmenuThumb", { bg = colors.accent2 })

set(0, "StatusLine", { fg = colors.main_bg, bg = colors.accent, bold = true })
set(0, "StatusLineNC", { fg = colors.fg4, bg = colors.bg3 })
set(0, "VertSplit", { fg = colors.bg4 })

set(0, "DiffAdd", { fg = colors.bone, bg = "#354135" })
set(0, "DiffChange", { fg = colors.clay, bg = "#3e3a35" })
set(0, "DiffDelete", { fg = colors.critical, bg = "#4a322f" })
set(0, "DiffText", { fg = colors.white, bg = colors.accent })

set(0, "SpellBad", { undercurl = true, sp = colors.critical })
set(0, "SpellCap", { undercurl = true, sp = colors.accent })
set(0, "SpellLocal", { undercurl = true, sp = colors.clay })
set(0, "SpellRare", { undercurl = true, sp = colors.warning })

set(0, "WarningMsg", { fg = colors.warning, bold = true })

-- Diagnostic highlighting for LSP (if used)
set(0, "DiagnosticError", { fg = colors.critical, bold = true })
set(0, "DiagnosticWarn", { fg = colors.warning, bold = true })
set(0, "DiagnosticInfo", { fg = colors.fg3 })
set(0, "DiagnosticHint", { fg = colors.ochre })

-- Cursor colors (if terminal supports)
set(0, "Cursor", { fg = colors.main_bg, bg = colors.accent })

-- More UI details can be added as needed
