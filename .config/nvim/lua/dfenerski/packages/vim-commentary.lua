return {
    'tpope/vim-commentary',
    config = function()
        -- Map <C-/> to <Plug>Commentary in visual mode
        vim.api.nvim_set_keymap('x', '<C-_>', '<Plug>Commentary', { silent = true })
        -- Map <C-/> to <Plug>CommentaryLine in normal mode
        vim.api.nvim_set_keymap('n', '<C-_>', '<Plug>CommentaryLine', { silent = true })
        -- Map <C-/> to <Plug>Commentary in operator-pending mode
        vim.api.nvim_set_keymap('o', '<C-_>', '<Plug>Commentary', { silent = true })
    end
}
