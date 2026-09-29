-- Komenda :KeymapsDoc: zapisuje wszystkie keymapy z opisem (desc) do KEYMAPS.md w katalogu configu.
-- Bierze mapy globalne i mapy bieżącego bufora, więc najlepiej uruchamiać z otwartym plikiem kodu.
-- Brak keymapów. Zależy tylko od wbudowanego API Neovima.

local modes = { 'n', 'i', 'x', 's', 'o', 't', 'c' } -- 'v' = x + s, więc go pomijamy

local function escape(s)
	return (s:gsub('|', '\\|'))
end

-- czy mapa pochodzi z pliku w katalogu configu (a nie z Neovima/pluginu)
local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))
local function is_mine(map)
	local info = map.sid and map.sid > 0 and vim.fn.getscriptinfo({ sid = map.sid })[1]
	return info ~= nil and info ~= false and vim.startswith(vim.fn.resolve(info.name), config_dir)
end

local function table_lines(rows, order)
	table.sort(order, function(a, b)
		local ra, rb = rows[a], rows[b]
		local la, lb = ra.lhs:lower(), rb.lhs:lower()
		if la ~= lb then return la < lb end
		return ra.desc < rb.desc
	end)
	local lines = { '| Tryb | Skrót | Opis |', '| --- | --- | --- |' }
	for _, key in ipairs(order) do
		local row = rows[key]
		table.insert(lines, string.format('| %s | `%s` | %s |',
			table.concat(row.modes, ', '), escape(row.lhs), escape(row.desc)))
	end
	return lines
end

local function generate()
	-- scal te same (skrót, opis) z różnych trybów w jeden wiersz: "n, x, o"
	local groups = { mine = { rows = {}, order = {} }, other = { rows = {}, order = {} } }
	for _, mode in ipairs(modes) do
		for _, maps in ipairs({ vim.api.nvim_get_keymap(mode), vim.api.nvim_buf_get_keymap(0, mode) }) do
			for _, map in ipairs(maps) do
				if map.desc and map.desc ~= '' then
					local lhs = vim.fn.keytrans(map.lhsraw or map.lhs)
					if vim.g.mapleader == ' ' then
						lhs = lhs:gsub('^<Space>', '<leader>')
					end
					local g = groups[is_mine(map) and 'mine' or 'other']
					local rows, order = g.rows, g.order
					local key = lhs .. '\0' .. map.desc
					if not rows[key] then
						rows[key] = { lhs = lhs, desc = map.desc, modes = {} }
						table.insert(order, key)
					end
					if not vim.tbl_contains(rows[key].modes, mode) then
						table.insert(rows[key].modes, mode)
					end
				end
			end
		end
	end

	local lines = {
		'# Keymapy',
		'',
		'<!-- Plik generowany przez :KeymapsDoc (lua/bartus/core/keymaps_doc.lua). Nie edytuj ręcznie. -->',
		'',
		'Tryby: n = normal, i = insert, x = visual, s = select, o = operator (po d/c/y), t = terminal, c = linia komend.',
		'`<leader>` = spacja. Skąd pochodzi mapa: `:verbose map <skrót>`.',
		'',
		'## Z mojego configu',
		'',
	}
	vim.list_extend(lines, table_lines(groups.mine.rows, groups.mine.order))
	vim.list_extend(lines, { '', '## Wbudowane i z pluginów', '' })
	vim.list_extend(lines, table_lines(groups.other.rows, groups.other.order))

	local path = vim.fn.stdpath('config') .. '/KEYMAPS.md'
	vim.fn.writefile(lines, path)
	vim.notify(string.format('KeymapsDoc: zapisano %d + %d skrótów do %s',
		#groups.mine.order, #groups.other.order, path))
end

vim.api.nvim_create_user_command('KeymapsDoc', generate, { desc = 'Wygeneruj KEYMAPS.md z keymapów z opisem' })
