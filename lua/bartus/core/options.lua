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
vim.o.clipboard = "unnamedplus" -- y/p korzystają ze schowka systemowego

-- zwijanie kodu przez treesitter; zf/zo/zc/za jak zwykle
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99 -- domyślnie wszystko rozwinięte
vim.o.foldlevelstart = 99

vim.diagnostic.config({
	virtual_text = true, -- błędy LSP na końcu linii
})
