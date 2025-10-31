vim.pack.add {
    { src = "https://github.com/L3MON4D3/LuaSnip" }
}

-- Configure LuaSnip
require("luasnip").config.set_config({
    history = true,
})

-- Load snippet
local ls = require("luasnip")

-- Typst snippet: "def"
ls.add_snippets("typst", {
    ls.s("def", {
        ls.t({"#def[", "  #underline["}),
        ls.i(1, "name"),
        ls.t({"]", "]"}),
    }),
})

vim.keymap.set({ "i", "s" }, "<C-e>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").expand_or_jump()
  end
end, { silent = true })



