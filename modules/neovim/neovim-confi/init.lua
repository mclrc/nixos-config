-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

--[[ require("mini.indentscope").setup({ draw = {
  animation = function()
    return 0
  end,
} }) ]]

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        inlay_hints = {
          typeHints = true,
          chainingHints = true,
          parameterHints = true,
          maxLength = 100,
        },
      },
    },
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.lsp.inlay_hint.enable(true)
  end,
})
