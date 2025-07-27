-- Telescope remaps
local telescope = require('telescope');
local builtin = require('telescope.builtin');
vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {});
vim.keymap.set('n', '<leader>ff', builtin.git_files, {});
vim.keymap.set('n', '<leader>fl', builtin.lsp_document_symbols, {}); -- {symbols={"method","function"}} or { ignore_symbols=variable }
vim.keymap.set('n', '<leader>sf', function()
    builtin.grep_string({ search = vim.fn.input("Search: ") });
end)

-- Harpoon remaps
local mark = require('harpoon.mark');
local ui = require('harpoon.ui');
vim.keymap.set('n', '<leader>ah', mark.add_file);
vim.keymap.set('n', '<leader>sh', ui.toggle_quick_menu);
--vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end);
--vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end);
--vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end);
--vim.keymap.set('n', '<C-s>', function() ui.nav_file(4) end);

-- Undotree remaps
vim.keymap.set('n', '<leader>z', vim.cmd.UndotreeToggle);

-- Neogit remaps
vim.keymap.set('n', '<leader>gs', vim.cmd.Git);

-- Disables capital Q
--vim.keymap.set("n", "Q", "<nop>")

-- Format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Close current file
vim.keymap.set("n", "<leader>x", vim.cmd.Ex)

-- Open parent directory
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Mark current file as executable
vim.keymap.set("n", "<leader>ex", "<cmd>!chmod +x %<CR>", { silent = true })

-- Enable vim-tmux-navigator intuitive navigation
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")

-- Ughh something with tmux I am yet to figure out https://youtu.be/w7i4amO_zaE?si=n4eO6SVGhI4JwBn9&t=1709
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Vim quickfix list navigation
vim.keymap.set("n", "<leader>j", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>cprev<CR>zz")

-- Vim local list navigation https://stackoverflow.com/questions/1747091/how-do-you-use-vims-quickfix-feature
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Space + <s>end current word to search & replace
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
