vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>fj", "<cmd>Oil<cr>")
-- Copy

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("v", "J", ":m .+1<CR>==gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m .-2<CR>==gv", { desc = "Move selected lines up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<Leader>w", ":update<Return>")
vim.keymap.set("n", "<Leader>q", ":quit<Return>")
vim.keymap.set("n", "<Leader>Q", ":qa<Return>")
