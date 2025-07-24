-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<Esc>", "<C-\\\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { desc = "Go to references" })
