-- Enable line numbers & relative line numbers
vim.opt.nu = true;
vim.opt.relativenumber = true;

-- Configure Spaces
vim.opt.tabstop = 4;
vim.opt.softtabstop = 4;
vim.opt.shiftwidth = 4;
vim.opt.expandtab = true;

-- Attempt to automatically indent new lines based on file type
vim.opt.smartindent = true;

-- Disable line wrapping
vim.opt.wrap = false;

-- Disable swap files in favor of undotree
vim.opt.swapfile = false;
vim.opt.backup = false;
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir';
vim.opt.undofile = true;

-- Highlight search results
vim.opt.hlsearch = false;

-- Incremental search results
vim.opt.incsearch = true;

-- Enable true color support (more colors)
vim.opt.termguicolors = true;

-- Add 'buffer' of 12 rows above and below cursor during scrolling
vim.opt.scrolloff = 12;

-- Always show the 'breakpoint' column
vim.opt.signcolumn = 'yes';

-- Add support for files which have `@` in the filename
vim.opt.isfname:append('@-@');

-- Generic faster update time
vim.opt.updatetime = 50;

-- Highlight the 80th column
-- vim.opt.colorcolumn = '80';

-- Set leader to be <Space>
vim.g.mapleader = ' ';

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
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Leader + delete into the void
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
