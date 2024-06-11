require "nvchad.mappings"

local map = vim.keymap.set

map("", "n", "h") -- left
map("", "e", "j") -- down
map("", "i", "k") -- up
map("", "o", "l") -- right

map("", "j", "y") -- yank
map("", "l", "u") -- undo
map("", "y", "o") -- newline
map("", "u", "i") -- insert

map("", "<C-w>n", "<C-w>h")
map("", "<C-w>e", "<C-w>j")
map("", "<C-w>i", "<C-w>k")
map("", "<C-w>o", "<C-w>l")

