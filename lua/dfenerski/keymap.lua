-- Move highlighted selection using J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move highlighted selection using J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Fix cursor position when <J>oining a line
vim.keymap.set("n", "J", "mzJ`z")

-- Jump half a page <u>p or <d>own while centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remap paste over selection to not yank selection
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Leader + yank into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Leader + delete into the void
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Close current file
vim.keymap.set("n", "<leader>x", vim.cmd.Ex)

-- Mark current file as executable
vim.keymap.set("n", "<leader>ex", "<cmd>!chmod +x %<CR>", { silent = true })

-- Enable nvim v0.10 native inlay hints
vim.keymap.set("n", "<leader>ih", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end)

-- Space + <s>end current word to search & replace
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Rebind nvim v0.10 native commenting, adapted from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_defaults.lua#L135
do
    local operator_rhs = function()
        return require('vim._comment').operator()
    end
    local line_rhs = function()
        return require('vim._comment').operator() .. '_'
    end
    local textobject_rhs = function()
        require('vim._comment').textobject()
    end

    vim.keymap.set({ 'n', 'x' }, '<C-_>', operator_rhs, { expr = true, desc = 'Toggle comment' })
    vim.keymap.set('n', '<C-_>', line_rhs, { expr = true, desc = 'Toggle comment line' })
    vim.keymap.set('o', '<C-_>', textobject_rhs, { desc = 'Comment textobject' })
end

