vim.pack.add({
    {src = 'https://github.com/hrsh7th/nvim-cmp'},
    {src = 'https://github.com/epwalsh/obsidian.nvim'},
})

require("obsidian").setup({
  workspaces = {
    { name = "cognition2", path = "~/Notes/cognition2" },
  },
  preferred_link_style = "wiki",
  completion = { nvim_cmp = true },
  daily_notes = { folder = "80 journal/2025/01 Daily" },
  ui = {
    enable = false,
  }
})


vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>", { desc = "New note" })
vim.keymap.set("n", "<leader>oo", ":ObsidianQuickSwitch<CR>", { desc = "Open note" })
vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>ot", ":ObsidianToday<CR>", { desc = "Today’s daily note" })
vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks<CR>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>ol", ":ObsidianLinks<CR>", { desc = "List links in note" })

