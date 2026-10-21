-- Notebooki Jupytera: .ipynb otwiera się jako markdown z blokami ```python (jupytext),
-- renderowany w buforze (render-markdown), z LSP w blokach (quarto + otter); komórki uruchamia
-- kernel Jupytera, a wyniki i wykresy widać pod kodem (molten + image.nvim).
-- Prefiks: <leader>j (jupyter) → ji jr jn ja jb jl jo jh jd jx jk jc; ]j [j skoki po komórkach.
-- Zależy od: jupytext.nvim, render-markdown.nvim, quarto-nvim, otter.nvim, molten-nvim,
-- image.nvim, venv ~/.virtualenvs/neovim (options.lua),
-- ImageMagick (`magick`) i terminala z protokołem grafiki kitty (Ghostty, kitty).
-- Wyłącza smear-cursor w buforach .ipynb (przez niego obrazki przerysowują się przy każdym ruchu).

-- obrazki w terminalu; w tmux potrzebne `allow-passthrough on`.
-- Bez UI (nvim --headless) image.nvim tylko ostrzega o rozmiarze terminala, więc pomijamy.
local has_ui = not vim.list_contains(vim.v.argv, "--headless")
if has_ui then
	require("image").setup({
		backend = "kitty",
		processor = "magick_cli",
		integrations = {}, -- tylko dla molten, bez obrazków w markdownie
		max_width = 100,
		max_height = 12,
		max_height_window_percentage = math.huge,
		max_width_window_percentage = math.huge,
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	})
end

vim.g.molten_image_provider = has_ui and "image.nvim" or "none"
vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = false -- wynik jako tekst pod komórką, okno na <leader>jo
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true
vim.g.molten_wrap_output = true
vim.g.molten_tick_rate = 200 -- jak często molten pyta kernel o wynik (domyślnie 500 ms)

-- .ipynb ↔ markdown: tekst notebooka to zwykły markdown, komórki kodu to bloki ```python.
-- Zapis (:w) wraca do .ipynb
require("jupytext").setup({
	style = "markdown",
	output_extension = "md",
	force_ft = "markdown",
})

-- renderowanie markdowna w buforze: nagłówki, listy, tabele, tło bloków kodu.
-- Działa we wszystkich plikach .md; w trybie insert widać surowy tekst
require("render-markdown").setup({
	file_types = { "markdown" },
	code = { border = "thick" }, -- pełne tło bloku kodu z nazwą języka
})

-- LSP (pyright) i uruchamianie w blokach kodu markdowna; otter trzyma ukryty bufor
-- z samym kodem, więc K, <leader>gd, <leader>cr i uzupełnianie działają jak w .py
require("quarto").setup({
	lspFeatures = {
		languages = { "python" },
		chunks = "all", -- jupytext pisze ```python, nie ```{python}
		diagnostics = { enabled = true, triggers = { "BufWritePost" } },
		completion = { enabled = true },
	},
	codeRunner = { enabled = true, default_method = "molten" },
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(ev)
		if not vim.api.nvim_buf_get_name(ev.buf):match("%.ipynb$") then
			return
		end
		require("quarto").activate()
		-- chowa nagłówek jupytext (metadane `---` … `---` na górze); widać go w trybie insert
		local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, 50, false)
		if lines[1] == "---" then
			for i = 2, #lines do
				if lines[i] == "---" then
					local ns = vim.api.nvim_create_namespace("notebook_header")
					vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
					vim.api.nvim_buf_set_extmark(ev.buf, ns, 0, 0, { end_row = i - 1, conceal_lines = "" })
					break
				end
			end
		end
	end,
})

-- komórki kodu: od linii ```język do zamykającej ```
local function cells()
	local list, open = {}, nil
	for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		if not open and line:match("^```%w") then
			open = i
		elseif open and line:match("^```%s*$") then
			table.insert(list, { first = open, last = i })
			open = nil
		end
	end
	return list
end

-- kursor na pierwszą linię kodu następnej / poprzedniej komórki
local function goto_cell(dir)
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local list = cells()
	local target
	for i = (dir > 0 and 1 or #list), (dir > 0 and #list or 1), dir do
		local line = list[i].first + 1
		if (dir > 0 and line > cur) or (dir < 0 and line < cur and not (cur <= list[i].last)) then
			target = line
			break
		end
	end
	if target then
		vim.api.nvim_win_set_cursor(0, { target, 0 })
	end
end

local runner = require("quarto.runner")
local map = vim.keymap.set
map("n", "<leader>ji", "<cmd>MoltenInit<cr>", { desc = "Uruchom kernel Jupytera" })
map("n", "<leader>jr", runner.run_cell, { desc = "Uruchom komórkę" })
map("n", "<leader>jn", function()
	runner.run_cell()
	goto_cell(1)
end, { desc = "Uruchom komórkę i przejdź do następnej" })
map("n", "<leader>ja", runner.run_all, { desc = "Uruchom wszystkie komórki" })
map("n", "<leader>jb", runner.run_above, { desc = "Uruchom komórki do bieżącej włącznie" })
map("n", "<leader>jl", runner.run_line, { desc = "Uruchom linię" })
map("x", "<leader>jr", runner.run_range, { desc = "Uruchom zaznaczenie" })
map("n", "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<cr>", { desc = "Pokaż wynik w oknie (drugi raz: wejdź)" })
map("n", "<leader>jh", "<cmd>MoltenHideOutput<cr>", { desc = "Ukryj okno wyniku" })
map("n", "<leader>jd", "<cmd>MoltenDelete<cr>", { desc = "Usuń wynik komórki" })
map("n", "<leader>jx", "<cmd>MoltenInterrupt<cr>", { desc = "Przerwij wykonywanie" })
map("n", "<leader>jk", "<cmd>MoltenRestart!<cr>", { desc = "Zrestartuj kernel (czyści wyniki)" })
map("n", "<leader>jc", function()
	-- poniżej bieżącej komórki kodu, a w tekście markdown: poniżej bieżącej linii
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local after = cur
	for _, c in ipairs(cells()) do
		if cur >= c.first and cur <= c.last then
			after = c.last
		end
	end
	vim.api.nvim_buf_set_lines(0, after, after, false, { "", "```python", "", "```" })
	vim.api.nvim_win_set_cursor(0, { after + 3, 0 })
	vim.cmd("startinsert")
end, { desc = "Dodaj komórkę kodu poniżej" })
map({ "n", "x", "o" }, "]j", function() goto_cell(1) end, { desc = "Przejdź do następnej komórki" })
map({ "n", "x", "o" }, "[j", function() goto_cell(-1) end, { desc = "Przejdź do poprzedniej komórki" })

-- przy otwarciu .ipynb: start kernela z metadanych notebooka i wczytanie zapisanych wyników
local function init_notebook(ev)
	if vim.b[ev.buf].notebook_init then
		return
	end
	vim.b[ev.buf].notebook_init = true
	vim.schedule(function()
		local ok, kernel = pcall(function()
			return vim.json.decode(io.open(ev.file, "r"):read("a")).metadata.kernelspec.name
		end)
		if ok and vim.tbl_contains(vim.fn.MoltenAvailableKernels(), kernel) then
			vim.cmd("MoltenInit " .. kernel)
			vim.cmd("MoltenImportOutput")
		end
	end)
end
vim.api.nvim_create_autocmd("BufAdd", { pattern = "*.ipynb", callback = init_notebook })
-- BufAdd nie odpala się dla pliku podanego przy starcie (`nvim plik.ipynb`)
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.ipynb",
	callback = function(ev)
		if vim.v.vim_did_enter ~= 1 then
			init_notebook(ev)
		end
	end,
})

-- :w zapisuje też wyniki komórek do .ipynb (jupytext zapisuje tylko kod)
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.ipynb",
	callback = function()
		if require("molten.status").initialized() == "Molten" then
			vim.cmd("MoltenExportOutput!")
		end
	end,
})

-- smear-cursor rysuje ogonek kursora okienkami pływającymi, a każde nowe/zamknięte okno
-- każe image.nvim przerysować wszystkie obrazki, więc w notebookach go wyłączamy
local smear = require("smear_cursor")
local smear_was_enabled
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.ipynb",
	callback = function()
		if smear_was_enabled == nil then
			smear_was_enabled = smear.enabled
		end
		smear.enabled = false
	end,
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.ipynb",
	callback = function()
		if smear_was_enabled ~= nil then
			smear.enabled = smear_was_enabled
			smear_was_enabled = nil
		end
	end,
})
