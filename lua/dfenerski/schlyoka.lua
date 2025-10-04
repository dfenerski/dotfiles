---------------------------------------------------------------------------
-- :Translate + <leader>t  —  Shlyokavica → Cyrillic
--   • Skips $…$ blocks unless they contain double quotes.
--   • Works on whole buffer or visual range.
--   • <leader>t in NORMAL → whole buffer, in VISUAL → selection.
---------------------------------------------------------------------------

-- 1. Explicit double-case rules (multichar combos before singles)
local rules = {
    { 'sht', 'щ' }, { 'Sht', 'Щ' },
    { 'sh', 'ш' }, { 'Sh', 'Ш' },
    { 'yu', 'ю' }, { 'Yu', 'Ю' },
    { 'ch', 'ч' }, { 'Ch', 'Ч' },
    { 'uu', 'ъ' }, { 'Uu', 'Ъ' },
    { 'c', 'ц' }, { 'C', 'Ц' },
    { 'j', 'ж' }, { 'J', 'Ж' },
    { 'y', 'й' }, { 'Y', 'Й' },
    { 'u', 'у' }, { 'U', 'У' },
    { 'a', 'а' }, { 'A', 'А' },
    { 'b', 'б' }, { 'B', 'Б' },
    { 'v', 'в' }, { 'V', 'В' },
    { 'g', 'г' }, { 'G', 'Г' },
    { 'd', 'д' }, { 'D', 'Д' },
    { 'e', 'е' }, { 'E', 'Е' },
    { 'z', 'з' }, { 'Z', 'З' },
    { 'i', 'и' }, { 'I', 'И' },
    { 'k', 'к' }, { 'K', 'К' },
    { 'l', 'л' }, { 'L', 'Л' },
    { 'm', 'м' }, { 'M', 'М' },
    { 'n', 'н' }, { 'N', 'Н' },
    { 'o', 'о' }, { 'O', 'О' },
    { 'p', 'п' }, { 'P', 'П' },
    { 'r', 'р' }, { 'R', 'Р' },
    { 's', 'с' }, { 'S', 'С' },
    { 't', 'т' }, { 'T', 'Т' },
    { 'f', 'ф' }, { 'F', 'Ф' },
    { 'h', 'х' }, { 'H', 'Х' },
    { 'q', 'я' }, { 'Q', 'Я' },
}

local function tr(txt)
    for _, r in ipairs(rules) do
        txt = txt:gsub(r[1], r[2])
    end
    return txt
end

-- translate one line, skipping $…$ regions unless quoted text inside
local function transliterate_line(line)
    local out, pos = {}, 1
    while true do
        local s, e = line:find('%b$$', pos) -- balanced $ … $
        if not s then                       -- no more $
            table.insert(out, tr(line:sub(pos)))
            break
        end
        if s > pos then -- text before $
            table.insert(out, tr(line:sub(pos, s - 1)))
        end
        local seg = line:sub(s + 1, e - 1) -- inside $ … $
        if seg:find('"') then              -- translate only quoted parts
            seg = seg:gsub('"(.-)"', function(q)
                return '"' .. tr(q) .. '"'
            end)
        end
        table.insert(out, '$' .. seg .. '$')
        pos = e + 1
    end
    return table.concat(out)
end

local function apply(buf, first, last)
    local lines = vim.api.nvim_buf_get_lines(buf, first, last + 1, false)
    for i = 1, #lines do
        lines[i] = transliterate_line(lines[i])
    end
    vim.api.nvim_buf_set_lines(buf, first, last + 1, false, lines)
end



vim.api.nvim_create_user_command('Translate', function(opts)
    local buf = vim.api.nvim_get_current_buf()
    if opts.range == 0 then
        apply(buf, 0, vim.api.nvim_buf_line_count(buf) - 1)
    else
        apply(buf, opts.line1 - 1, opts.line2 - 1)
    end
end, { desc = 'Shlyokavica → Cyrillic (skip $…$ unless quoted)', range = true })

-- 2.  <leader>t mappings
vim.keymap.set('n', '<leader>t', ':Translate<CR>',
    { noremap = true, silent = true, desc = 'Translate buffer' })
vim.keymap.set('v', '<leader>t', ':Translate<CR>',
    { noremap = true, silent = true, desc = 'Translate selection' })


--