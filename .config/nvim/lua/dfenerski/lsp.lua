-- Keep track of commonly used lsp clients
local known_lsp_clients = {};

-- Setup remaps on lsp attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }

        -- Common LSP nav remaps
        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
        vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)

        -- Manual save hook, organize imports, then format. Meant for js/ts files (biome and tsserver)
        vim.keymap.set('n', '<leader>w', function()
            local tsserver_client = vim.lsp.get_client_by_id(known_lsp_clients.tsserver);

            -- Manual save hook for js/ts files
            if tsserver_client then
                tsserver_client.request(
                    'workspace/executeCommand',
                    {
                        command = '_typescript.organizeImports',
                        arguments = { vim.api.nvim_buf_get_name(event.buf) },
                        title = ''
                    },
                    function()
                        local biome_client = vim.lsp.get_client_by_id(known_lsp_clients.biome);

                        -- Abort if biome client is not available
                        if not biome_client then return end

                        biome_client.request(
                            'textDocument/formatting',
                            vim.lsp.util.make_formatting_params({}),
                            function(_, r2)
                                -- Abort if no changes are yielded form formatting
                                if not r2 then return end

                                -- Apply changes
                                vim.lsp.util.apply_text_edits(r2, event.buf, biome_client.offset_encoding)

                                -- Manually save the buffer
                                vim.cmd('write')
                            end,
                            opts.buffer
                        );
                    end,
                    opts.buffer
                );
            end

            -- Manual format and save other file types
            if vim.bo.filetype ~= 'js' and vim.bo.filetype ~= 'ts' and vim.bo.filetype ~= 'json' then
                vim.lsp.buf.format({ bufnr = event.buf });
                vim.cmd('write');
            end
        end, opts)

        -- Open [e]rror [l]ist in quickfix window
        vim.keymap.set('n', '<leader>el', function() vim.diagnostic.setqflist() end, opts)

        -- Open [e]rror [d]etails window
        vim.keymap.set('n', '<leader>ed', function()
            vim.diagnostic.open_float();
            vim.diagnostic.open_float() -- Execute again to enter the error window
        end, opts)
    end,
})

-- Setup lsp-status
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'i',
    indicator_hint = '?',
    indicator_ok = 'Ok',
})

-- Initialize lsp capabilities
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Extend capabilities with lsp-status capabilities
lsp_capabilities = vim.tbl_extend('keep', lsp_capabilities, lsp_status.capabilities)

-- Setup mason
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'biome',
        'eslint',
        'tsserver',
        'cssls',
        'terraformls',
        'lemminx',
        'sqlls',
        'pyright',
        'bashls',
        'lua_ls',
        'rust_analyzer'
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({
                capabilities = lsp_capabilities,
                on_attach = function(client, bufnr)
                    -- Connect to lsp-status
                    lsp_status.on_attach(client)
                end
            })
        end,
        biome = function()
            require('lspconfig').biome.setup({
                capabilities = lsp_capabilities,
                on_attach = function(client, bufnr)
                    -- Connect to lsp-status
                    lsp_status.on_attach(client)

                    -- Register as known lsp client
                    known_lsp_clients.biome = client.id
                end
            })
        end,
        tsserver = function()
            require('lspconfig').tsserver.setup({
                capabilities = lsp_capabilities,
                on_attach = function(client, bufnr)
                    -- Disable tsserver formatting in favor of biome
                    client.server_capabilities.documentFormattingProvider = false

                    -- Connect to lsp-status
                    lsp_status.on_attach(client)

                    -- Register as known lsp client
                    known_lsp_clients.tsserver = client.id
                end,
                -- Enable inlay hints, see also global.lua
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true
                        }
                    }
                },
            })
        end,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                capabilities = lsp_capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        }
                    }
                },
                on_attach = function(client, bufnr)
                    -- Connect to lsp-status
                    lsp_status.on_attach(client)
                end
            })
        end,
    }
})

-- Setup cmp
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        -- Enable autocompletions using tab, with fallback when 'not completing'
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

-- Setup gitsigns
require('gitsigns').setup()
