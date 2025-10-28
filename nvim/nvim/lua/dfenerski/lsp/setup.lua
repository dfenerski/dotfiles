vim = vim
vim.pack.add {
    { src = 'https://github.com/neovim/nvim-lspconfig' },
}

-- Format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Enable nvim v0.10 native inlay hints
vim.keymap.set("n", "<leader>ih", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end)

--
vim.diagnostic.config({ virtual_text = true })

--
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
        end
    end
})

-- Per-client LSP configurations

-- Explicit config required for formatting capabilities
vim.lsp.config("tinymist", {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {
        formatterMode = "typstyle",
    },
})

-- Disable formatting using `typescript-language-server`    
vim.lsp.config('ts_ls', {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})

-- TODO: https://biomejs.dev/guides/big-projects/#monorepo
vim.lsp.config('biome', {
    -- on_attach = function(client, bufnr)
    --     client.server_capabilities.documentFormattingProvider = true
    --     vim.api.nvim_create_autocmd('BufWritePre', {
    --         buffer = bufnr,
    --         callback = function()
    --             -- format using Biome (Prettier-like)
    --             vim.lsp.buf.format({ bufnr = bufnr })
    --             -- run Biome’s fixAll action to sort imports and remove unused
    --             vim.lsp.buf.code_action({
    --                 context = { only = { 'source.fixAll.biome' }, diagnostics = {} },
    --                 apply = true,
    --             })
    --         end,
    --     })
    -- end,
})

vim.lsp.enable({
    "lua_ls",
    "pyright",
    "tinymist",
    "ts_ls",
    "biome"
})
