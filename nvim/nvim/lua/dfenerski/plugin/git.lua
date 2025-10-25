vim.pack.add({
    {src = 'https://github.com/tpope/vim-fugitive'},
    {src = 'https://github.com/lewis6991/gitsigns.nvim'},
})

vim.keymap.set('n', '<leader>gs', vim.cmd.Git);

-- Setup gitsigns
require('gitsigns').setup()
