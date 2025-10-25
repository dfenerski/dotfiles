vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

-- nix profile install nixpkgs#lua-language-server
-- nix profile install nixpkgs#pyright
-- nix profile install nixpkgs#tinymist
-- nix profile install nixpkgs#typescript-language-server

-- Explicit config required for formatting capabilities
vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  settings = {
    formatterMode = "typstyle",
  },
})

vim.lsp.enable({
    "lua_ls", 
    "pyright", 
    "tinymist",
    "ts_ls"
})

