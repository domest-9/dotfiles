-- return {
--   "nvim-lualine/lualine.nvim",
--   dependencies = { "nvim-tree/nvim-web-devicons", optional = true },
--   event = "VeryLazy",
--   opts = function()
--     local icons = {
--       diagnostics = {
--         Error = " ",
--         Warn = " ",
--         Info = " ",
--         Hint = " ",
--       },
--       git = {
--         added = "+",
--         modified = "~",
--         removed = "-",
--       },
--     }
--
--     return {
--       options = {
--         theme = "auto",
--         globalstatus = true,
--         disabled_filetypes = { statusline = { "dashboard", "alpha" } },
--       },
--       sections = {
--         lualine_a = { "mode" },
--         lualine_b = { "branch" },
--         lualine_c = {
--           { "filename", path = 1 },
--           {
--             "diagnostics",
--             symbols = {
--               error = icons.diagnostics.Error,
--               warn  = icons.diagnostics.Warn,
--               info  = icons.diagnostics.Info,
--               hint  = icons.diagnostics.Hint,
--             },
--           },
--         },
--         lualine_x = {
--           {
--             "diff",
--             symbols = {
--               added    = icons.git.added,
--               modified = icons.git.modified,
--               removed  = icons.git.removed,
--             },
--           },
--           {
--             function()
--               return " " .. os.date("%H:%M")
--             end,
--           },
--         },
--         lualine_y = {
--           {
--             "fileformat",
--             symbols = {
--               unix = "", -- LF
--               dos  = "", -- CRLF
--               mac  = "", -- CR
--             },
--           },
--           "progress",
--         },
--         lualine_z = { "location" },
--       },
--       extensions = { "neo-tree", "lazy" },
--     }
--   end,
-- }



return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", optional = true },
  event = "VeryLazy",
  opts = function()
    local icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      },
      git = {
        added = "+",
        modified = "~",
        removed = "-",
      },
    }

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "filename", path = 1 },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn  = icons.diagnostics.Warn,
              info  = icons.diagnostics.Info,
              hint  = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          {
            "diff",
            symbols = {
              added    = icons.git.added,
              modified = icons.git.modified,
              removed  = icons.git.removed,
            },
          },
          {
            function()
              return " " .. os.date("%H:%M")
            end,
          },
        },
        lualine_y = {
          {
            "fileformat",
            symbols = {
              unix = "", -- LF
              dos  = "", -- CRLF
              mac  = "", -- CR
            },
          },
          {
            "filetype",
            icon_only = false,
            colored = false, -- ← disables icon color
          },
        },
        lualine_z = {
          "progress", -- ← moved to far right
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
