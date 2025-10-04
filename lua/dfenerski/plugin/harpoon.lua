vim.pack.add({
    {src = 'https://github.com/ThePrimeagen/harpoon'},
})

local mark = require('harpoon.mark');
local ui = require('harpoon.ui');

vim.keymap.set('n', '<leader>ah', mark.add_file);
vim.keymap.set('n', '<leader>sh', ui.toggle_quick_menu);