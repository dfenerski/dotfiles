return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.7',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            version = "1.1.0",
        }
    },
    config = function()
        local telescope = require('telescope')

        telescope.setup({
            defaults = {
                path_display = { 'truncate' },
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")
    end,
}
