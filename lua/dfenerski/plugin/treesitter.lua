vim.pack.add({
    {src = 'https://github.com/nvim-treesitter/nvim-treesitter'},
    {src = 'https://github.com/nvim-treesitter/playground'},
});

local configs = require("nvim-treesitter.configs");

configs.setup({
    ignore_install = {
        "help"
    },
    ensure_installed = {
        "help",
        "query",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "sql",
        "rust",
        "python",
        "go",
        "julia"
    },
    sync_install = false,
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
});