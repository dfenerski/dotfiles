
vim.pack.add({
    {src = 'https://github.com/maxmx03/solarized.nvim'},
})


local theme = 'dark'

vim.o.termguicolors = true
vim.o.background = theme

require('solarized').setup(opts)

vim.cmd.colorscheme 'solarized'

