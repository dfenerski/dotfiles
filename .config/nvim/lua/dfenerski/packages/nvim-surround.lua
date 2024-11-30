return {
    "kylechui/nvim-surround",
    version = "^2.3.0",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
}
