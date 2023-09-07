-- Line numbers, relative line numbers
vim.opt.nu = true;
vim.opt.relativenumber = true;

-- Spaces
vim.opt.tabstop = 4;
vim.opt.softtabstop = 4;
vim.opt.shiftwidth = 4;
vim.opt.expandtab = true;

-- Sure whatever yes
vim.opt.smartindent = true;

-- I guess wraps suck
vim.opt.wrap = false;

-- Disable swap files in favor of undotree
vim.opt.swapfile = false;
vim.opt.backup = false;
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir';
vim.opt.undofile = true;

-- No global but still incremental search
vim.opt.hlsearch = true;
vim.opt.incsearch = true;

-- More colors
vim.opt.termguicolors = true;

-- Try to scroll 8 lines before cursor hits last visible line
vim.opt.scrolloff = 8;
vim.opt.signcolumn = 'yes';
vim.opt.isfname:append('@-@');

-- Faster update
vim.opt.updatetime = 50;

-- Highlight the 80th column
-- vim.opt.colorcolumn = '80';

-- Set leader to be <Space>
vim.g.mapleader = ' ';
