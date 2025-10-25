vim.pack.add({
    {src = 'https://github.com/nvim-lua/plenary.nvim'},
    {src = 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim'},
    -- {src = 'https://github.com/junegunn/fzf'},
    -- {src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim'},
    {src = 'https://github.com/nvim-telescope/telescope.nvim'},
})

local telescope = require('telescope')
local builtin = require('telescope.builtin');

telescope.setup({
    defaults = {
        path_display = { 'truncate' },
    }
})

-- telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")

vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {});
vim.keymap.set('n', '<leader>ff', builtin.git_files, {});
vim.keymap.set('n', '<leader>fl', builtin.lsp_document_symbols, {}); -- {symbols={"method","function"}} or { ignore_symbols=variable }
vim.keymap.set('n', '<leader>sf', function()
    builtin.grep_string({ search = vim.fn.input("Search: ") });
end)
