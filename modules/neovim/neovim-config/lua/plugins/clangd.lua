return {
  {
    "neovim/nvim-lspconfig",
    -- No mason.nvim or mason-lspconfig.nvim dependencies here
    opts = {
      servers = {
        clangd = {},
      },
    },
    config = function(_, opts)
      -- This line sets up the default LSP servers from LazyVim
      -- require("lazyvim.plugins.lsp.init").setup.servers(opts.servers)

      -- Directly set up clangd using lspconfig
      require("lspconfig").clangd.setup({
        -- You can add any specific clangd settings here if needed
      })
    end,
  },
}
