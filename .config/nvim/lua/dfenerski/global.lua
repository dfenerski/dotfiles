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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Leader + delete into the void
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Enable nvim v0.10 native inlay hints
vim.keymap.set("n", "<leader>ih", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end)

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

-- Custom Lua function to remove an item from the quickfix list, adapted from vimscript https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
do
    local function remove_qf_item()
        vim.api.nvim_exec2([[
        let curqfidx = line('.') - 1
        let qfall = getqflist()
        call remove(qfall, curqfidx)
        call setqflist(qfall, 'r')
        execute curqfidx + 1 . "cfirst"
        copen
    ]], { output = false })
    end
    -- Create a command that calls the Lua function
    vim.api.nvim_create_user_command('RemoveQFItem', remove_qf_item, {})
    -- Set up an autocommand that maps 'dd' to the new command in quickfix windows
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', 'dd', ':RemoveQFItem<CR>', { noremap = true, silent = true })
        end
    })

    -- Custom Lua function to add the current file to the Quickfix list and open the Quickfix window
    local function add_current_file_to_qf()
        -- Get the current file path and line number
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_line = vim.api.nvim_get_current_line()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        local line_number = cursor_position[1]
        local column_number = cursor_position[2] + 1
        -- Define a Quickfix entry
        local qf_entry = {
            {
                filename = current_file,
                lnum = line_number,
                col = column_number,
                text = current_line
            }
        }
        -- [a]ppend the entry to the Quickfix list and open the Quickfix window
        vim.fn.setqflist(qf_entry, 'a')
        vim.cmd('copen')
    end

    -- Create a command to call this function easily from Neovim
    vim.api.nvim_create_user_command('AddCurrentFileToQF', add_current_file_to_qf, {})
    -- Set an autocommand or mapping to call this function
    vim.api.nvim_set_keymap('n', '<Leader>aq', ':AddCurrentFileToQF<CR>', { noremap = true, silent = true })
end
