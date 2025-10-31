---------------------------------------------------------------------------
-- :Translate + <leader>t  —  Shlyokavica → Cyrillic
--   • Skips $…$ blocks unless they contain double quotes.
--   • Works on whole buffer or visual range.
--   • <leader>t in NORMAL → whole buffer, in VISUAL → selection.
---------------------------------------------------------------------------

vim = vim

-- 1. Explicit double-case rules (multichar combos before singles)
local rules = {
    { 'sht', 'щ' }, { 'Sht', 'Щ' },
    { 'sh', 'ш' }, { 'Sh', 'Ш' },
    { 'yu', 'ю' }, { 'Yu', 'Ю' },
    { 'ch', 'ч' }, { 'Ch', 'Ч' },
    { 'c', 'ц' }, { 'C', 'Ц' },
    { 'j', 'й' }, { 'J', 'Й' },
    { 'y', 'ъ' }, { 'Y', 'Ъ' },
    { 'u', 'у' }, { 'U', 'У' },
    { 'a', 'а' }, { 'A', 'А' },
    { 'b', 'б' }, { 'B', 'Б' },
    { 'w', 'в' }, { 'W', 'В' },
    { 'v', 'ж' }, { 'V', 'Ж' },
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

-- helper: temporarily protect identifiers preceded by '#'
local function protect_hash_identifiers(s)
    local protected = {}
    local i = 0
    s = s:gsub("#([%w_]+)", function(id)
        i = i + 1
        local token = "\1" .. i .. "\2" -- unique placeholder
        protected[token] = "#" .. id
        return token
    end)
    return s, protected
end

-- helper: restore protected identifiers
local function restore_protected(s, protected)
    for token, orig in pairs(protected) do
        s = s:gsub(token, orig)
    end
    return s
end

local function transliterate_line(line)
    local out, pos = {}, 1
    while true do
        local itypstart, itypend = line:find("%b$$", pos)

        -- no more $
        if not itypstart then
            local segment, protected = protect_hash_identifiers(line:sub(pos))
            table.insert(out, restore_protected(tr(segment), protected))
            break
        end

        -- before $
        if itypstart > pos then
            local segment, protected = protect_hash_identifiers(line:sub(pos, itypstart - 1))
            table.insert(out, restore_protected(tr(segment), protected))
        end

        -- inside $…$
        local seg = line:sub(itypstart + 1, itypend - 1)
        if seg:find('"') then
            seg = seg:gsub('"(.-)"', function(q)
                local qs, protected = protect_hash_identifiers(q)
                return '"' .. restore_protected(tr(qs), protected) .. '"'
            end)
        end
        table.insert(out, "$" .. seg .. "$")

        pos = itypend + 1
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
vim.keymap.set('v', '<leader>t', ':Translate<CR>',
    { noremap = true, silent = true, desc = 'Translate selection' })


