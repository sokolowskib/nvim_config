-- Opcje edytora (vim.o), klawisz <leader> i wygląd diagnostyk.
-- Brak keymapów. Ładowany jako pierwszy: <leader> musi być ustawiony przed
-- jakimkolwiek vim.keymap.set, inaczej mapy dostaną stary leader.

vim.g.mapleader = " "

-- numeracja i wygląd okna
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.winborder = "rounded" -- ramki okien pływających (hover, diagnostyka, sygnatury)
vim.o.termguicolors = true

-- wcięcia
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.swapfile = false

-- Python dla pluginów (molten): osobny venv z pynvim, jupyter_client, jupytext
-- (patrz README, sekcja o notebookach); bin/ na końcu PATH daje komendę `jupytext`
-- bez przysłaniania systemowego pythona
local nvim_venv = vim.fn.expand("~/.virtualenvs/neovim")
vim.g.python3_host_prog = nvim_venv .. "/bin/python"
vim.env.PATH = vim.env.PATH .. ":" .. nvim_venv .. "/bin"
vim.o.clipboard = "unnamedplus" -- y/p korzystają ze schowka systemowego

-- zwijanie kodu przez treesitter; zf/zo/zc/za jak zwykle
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99 -- domyślnie wszystko rozwinięte
vim.o.foldlevelstart = 99

vim.diagnostic.config({
	virtual_text = { prefix = "●" }, -- błędy LSP na końcu linii
	severity_sort = true,           -- błąd wygrywa z ostrzeżeniem w tej samej linii
	signs = {                       -- ikony w kolumnie po lewej zamiast liter E/W/I/H
		text = {
			[vim.diagnostic.severity.ERROR] = "\u{f057}",
			[vim.diagnostic.severity.WARN] = "\u{f071}",
			[vim.diagnostic.severity.INFO] = "\u{f05a}",
			[vim.diagnostic.severity.HINT] = "\u{f0335}",
		},
	},
})
