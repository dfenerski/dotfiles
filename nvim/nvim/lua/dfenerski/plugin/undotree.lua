vim.pack.add({
    {src = 'https://github.com/mbbill/undotree'},
})

vim.keymap.set('n', '<leader>z', vim.cmd.UndotreeToggle);