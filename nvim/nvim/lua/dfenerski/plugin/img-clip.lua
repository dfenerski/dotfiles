vim.pack.add({ { src = "https://github.com/HakonHarnes/img-clip.nvim" } })

require("img-clip").setup(
    {
        filetypes = {
            typst = {
                template = "#image(\"$FILE_PATH\", width: 80%)",
            }
        },
    }
);

vim.keymap.set("n", "<leader>mm", "<cmd>PasteImage<CR>", { desc = "Paste image from clipboard" })
