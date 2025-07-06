return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {},
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<Leader><Tab>",
      },
    },
    filetypes = {
      ["*"] = true,
    },
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    insert_mappings = true,
    terminal_mappings = true,
    keys = {
      { "<M-1>", "<cmd>ToggleTerm 1 direction=horizontal dir=git_dir size=30<CR>" },
      { "<M-2>", "<cmd>ToggleTerm 2 direction=vertical dir=git_dir size=70<CR>" },
      { "<M-3>", "<cmd>ToggleTerm 3 direction=float dir=git_dir<CR>" },
    },
    config = function()
      require("toggleterm").setup()
    end,
  },
  { "f-person/git-blame.nvim" },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "echasnovski/mini.comment",
    config = function()
      require("mini.comment").setup()
    end,
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
}
