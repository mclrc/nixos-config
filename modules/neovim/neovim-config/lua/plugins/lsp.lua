-- All LSP configurations for NixOS (without Mason)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {},
        ts_ls = {},
        eslint = {},
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      -- Setup clangd
      lspconfig.clangd.setup({
        -- Add any specific clangd settings here if needed
      })

      -- Setup TypeScript language server
      lspconfig.ts_ls.setup({
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- Setup ESLint language server
      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- Setup Vue language server (volar)
      lspconfig.volar.setup({
        filetypes = { "vue" },
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      })

      -- Setup HTML and CSS language servers (from vscode-langservers-extracted)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.html.setup({ capabilities = capabilities, filetypes = { "html", "vue" } })
      lspconfig.cssls.setup({ capabilities = capabilities })
    end,
  },
}
