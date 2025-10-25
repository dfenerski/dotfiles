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

-- Other settings
vim.opt.winborder = "rounded";
