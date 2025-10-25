
vim.pack.add({
    {src = 'https://github.com/maxmx03/solarized.nvim'},
})


vim.o.termguicolors = true
-- vim.o.background = 'light'
vim.o.background = 'dark'
require('solarized').setup(opts)
vim.cmd.colorscheme 'solarized'

