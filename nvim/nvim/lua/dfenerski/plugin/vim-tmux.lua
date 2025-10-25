vim.pack.add({
    {src = 'https://github.com/christoomey/vim-tmux-navigator'},
    {src = 'https://github.com/roxma/vim-tmux-clipboard'},
})


-- Enable vim-tmux-navigator intuitive navigation
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")
