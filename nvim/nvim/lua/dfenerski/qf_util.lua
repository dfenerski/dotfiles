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

-- Vim quickfix list navigation
vim.keymap.set("n", "<leader>j", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>cprev<CR>zz")