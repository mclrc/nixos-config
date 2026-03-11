-- All LSP configurations for NixOS (without Mason)
-- Uses LazyVim's opts.servers system so LazyVim's default config runs,
-- which provides keymaps (K, gd, gr), diagnostics, and cmp capabilities.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {},
        ts_ls = {
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
        },
        eslint = {},
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },
        html = {
          filetypes = { "html", "vue" },
        },
        cssls = {},
      },
      -- ESLint: auto-fix on save
      setup = {
        eslint = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "eslint" then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = args.buf,
                  command = "EslintFixAll",
                })
              end
            end,
          })
        end,
      },
    },
  },
}
