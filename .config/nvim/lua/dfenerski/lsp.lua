local lsp = require('lsp-zero');

-- Enable recommended preset
lsp.preset('recommended');

-- Add relevant LSPs
lsp.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer'
})

-- Configure suggestion popup behavior
local cmp = require('cmp');
local cmp_select = { behavior = cmp.SelectBehavior.Select };
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['C-p'] = cmp.mapping.select_prev_item(cmp_select),
    ['C-n'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['C-Space'] = cmp.mapping.complete(),
});
lsp.setup_nvim_cmp({
    mapping = cmp_mappings
});

-- On lsp attached-to-buffer hook
lsp.on_attach(function(_client, bufnr)
    local options = { buffer = bufnr, remap = false };

    vim.keymap.set('n', '<F12>', function() vim.lsp.buf.definition() end, options);
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, options);
    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, options);
    vim.keymap.set('n', '<leader>vw', function() vim.diagnostic.open_float() end, options);
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, options);
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, options);
    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, options);
    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, options);
    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, options);
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, options);
end)

-- Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- Bootstrap
lsp.setup()

