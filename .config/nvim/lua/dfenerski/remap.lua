-- telescope remaps
local builtin = require('telescope.builtin');
vim.keymap.set('n', '<leader>ffa', builtin.find_files, {});
vim.keymap.set('n', '<leader>ff', builtin.git_files, {});
vim.keymap.set('n', '<leader>s', function()
	builtin.grep_string({ search = vim.fn.input('Search:') });
end)

-- harpoon remaps
local mark = require('harpoon.mark');
local ui = require('harpoon.ui');
vim.keymap.set('n', '<leader>h', mark.add_file);
vim.keymap.set('n', '<leader>hm', ui.toggle_quick_menu);
-- Enable quick access to harpooned files
--vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end);
--vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end);
--vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end);
--vim.keymap.set('n', '<C-s>', function() ui.nav_file(4) end);

-- undotree remaps
vim.keymap.set('n', '<leader><F3>', vim.cmd.UndotreeToggle);

-- vim-fugitive remaps
vim.keymap.set('n', '<leader>gs', vim.cmd.Git);

-- global remaps
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
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Leader + delete into the void
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Disables capital Q
vim.keymap.set("n", "Q", "<nop>")

-- Ughh something with tmux I am yet to figure out
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Something about navigation idk 
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Space + <s>end current word to search & replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Mark current file as executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

