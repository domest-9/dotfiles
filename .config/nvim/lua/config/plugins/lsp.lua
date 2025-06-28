return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        "saghen/blink.cmp",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("lspconfig").clangd.setup { capabilities = capabilities }
      require("lspconfig").lua_ls.setup { capabilities = capabilities }

      --
      --
      -- Enhanced LSP diagnostic configuration for better productivity and aesthetics
      vim.diagnostic.config({
        virtual_text = {
          spacing = 6, -- More breathing room
          prefix = "◉", -- Modern bullet point (alternatives: "●", "▎", "", "", "")
          suffix = "", -- Optional suffix
          source = "if_many", -- Show source when multiple sources available
          format = function(diagnostic)
            -- Custom formatting for more informative messages
            local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
            local source = diagnostic.source and string.format(" (%s)", diagnostic.source) or ""

            -- Truncate very long messages to keep them readable
            local message = diagnostic.message
            if #message > 80 then
              message = message:sub(1, 77) .. "..."
            end

            return string.format("%s%s%s", message, code, source)
          end,
        },

        signs = {
          active = true,
          values = {
            { name = "DiagnosticSignError", text = "" }, -- or "", "", "✘"
            { name = "DiagnosticSignWarn",  text = "" }, -- or "", "", "⚠"
            { name = "DiagnosticSignInfo",  text = "" }, -- or "", "", "ℹ"
            { name = "DiagnosticSignHint",  text = "" }, -- or "", "", "💡"
          }
        },

        underline = {
          severity = { min = vim.diagnostic.severity.WARN }, -- Only underline warnings and errors
        },

        float = {
          focusable = false,
          style = "minimal",
          border = "rounded", -- Options: "single", "double", "rounded", "solid", "shadow"
          source = "always",  -- Show source in floating window
          header = "",        -- Remove default header
          prefix = function(diagnostic, i, total)
            -- Custom prefix for floating diagnostics
            local icons = { "", "", "", "" }
            local severities = { "Error", "Warn", "Info", "Hint" }
            local severity = diagnostic.severity
            return string.format("%s ", icons[severity] or "")
          end,
          suffix = function(diagnostic)
            -- Add source and code information
            local parts = {}
            if diagnostic.source then
              table.insert(parts, diagnostic.source)
            end
            if diagnostic.code then
              table.insert(parts, string.format("[%s]", diagnostic.code))
            end
            return #parts > 0 and string.format(" (%s)", table.concat(parts, " ")) or ""
          end,
          format = function(diagnostic)
            -- Better formatting for floating window
            return diagnostic.message
          end,
        },

        update_in_insert = false, -- Less distracting
        severity_sort = true,     -- Show most severe first
      })

      -- Enhanced highlight groups for better visual distinction
      local signs = {
        Error = "", -- or "", "", "✘"
        Warn = "",  -- or "", "", "⚠"
        Info = "",  -- or "", "", "ℹ"
        Hint = "",  -- or "", "", "💡"
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Custom colors for better contrast and readability
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
        fg = "#ff6b6b",
        bg = "#2d1b1b",
        italic = true
      })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
        fg = "#feca57",
        bg = "#2d2416",
        italic = true
      })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
        fg = "#54a0ff",
        bg = "#1a2332",
        italic = true
      })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
        fg = "#5f27cd",
        bg = "#221a2d",
        italic = true
      })

      -- Keymaps for better diagnostic navigation
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Set diagnostic loclist" })

      -- Enhanced goto functions with better UX
      vim.keymap.set('n', '[e', function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Go to previous error" })

      vim.keymap.set('n', ']e', function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Go to next error" })

      vim.keymap.set('n', '[w', function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
      end, { desc = "Go to previous warning" })

      vim.keymap.set('n', ']w', function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
      end, { desc = "Go to next warning" })

      -- Auto-show diagnostics in floating window on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
          -- Only show if there are diagnostics on the current line
          local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
          if #line_diagnostics > 0 then
            vim.diagnostic.open_float(nil, {
              focus = false,
              scope = "cursor" -- Only show diagnostics for current cursor position
            })
          end
        end,
      })

      -- Optional: Toggle diagnostics visibility
      vim.keymap.set('n', '<leader>td', function()
        local current = vim.diagnostic.config().virtual_text
        if current then
          vim.diagnostic.config({ virtual_text = false })
          print("Diagnostics hidden")
        else
          vim.diagnostic.config({
            virtual_text = {
              spacing = 6,
              prefix = "◉",
              source = "if_many",
              format = function(diagnostic)
                local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
                local source = diagnostic.source and string.format(" (%s)", diagnostic.source) or ""
                local message = diagnostic.message
                if #message > 80 then
                  message = message:sub(1, 77) .. "..."
                end
                return string.format("%s%s%s", message, code, source)
              end,
            }
          })
          print("Diagnostics shown")
        end
      end, { desc = "Toggle diagnostics" })

      ---------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Autoformat on save
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = args.buf,
                  id = client.id,
                  timeout_ms = 1000,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}


























-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       {
--         "folke/lazydev.nvim",
--         'saghen/blink.cmp',
--         ft = "lua", -- only load on lua files
--         opts = {
--           library = {
--             { path = "${3rd}/luv/library", words = { "vim%.uv" } },
--           },
--         },
--       },
--     },
--     config = function()
--       local capabilities = require('blink.cmp').get_lsp_capabilities()
--       require("lspconfig").clangd.setup { capabilities = capabilities }
--       require("lspconfig").lua_ls.setup { capabilities = capabilities }
--
--
--       vim.diagnostic.config({
--         virtual_text = false,
--         signs = true,
--         underline = true,
--         update_in_insert = false,
--         severity_sort = true,
--       })
--
--       vim.api.nvim_create_autocmd('LspAttach', {
--         callback = function(args)
--           local client = vim.lsp.get_client_by_id(args.data.client_id)
--           if not client then return end
--
--           -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
--           if client:supports_method('textDocument/formatting') then
--             vim.api.nvim_create_autocmd('BufWritePre', {
--               buffer = args.buf,
--               callback = function()
--                 vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
--               end,
--             })
--           end
--         end,
--       })
--     end,
--   }
-- }
--


----------------------------------------------------------
-----------------------------------------------------------------
--
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--   {
--     "folke/lazydev.nvim",
--     ft = "lua", -- only load on lua files
--     opts = {
--       library = {
--         -- See the configuration section for more details
--         -- Load luvit types when the `vim.uv` word is found
--         { path = "${3rd}/luv/library", words = { "vim%.uv" } },
--       },
--     },
--   },
--     config = function()
--       require("lspconfig").lua_ls.setup {}
--
--       -- Configure diagnostics display
--       vim.diagnostic.config({
--         virtual_text = true,      -- inline text next to code
--         signs = true,             -- signs in gutter
--         underline = true,         -- underline issues
--         update_in_insert = false, -- don't update in insert mode
--         severity_sort = true,
--         float = {
--           border = "rounded",    -- floating window border style
--           source = "always",     -- always show source in float
--           header = "",
--           prefix = "",
--         },
--       })
--
--       -- Show floating diagnostics window on cursor hold
--       vim.api.nvim_create_autocmd("CursorHold", {
--         buffer = 0,
--         callback = function()
--           vim.diagnostic.open_float(nil, { border = "rounded" })
--         end,
--       })
--     end,
--   }
-- }
