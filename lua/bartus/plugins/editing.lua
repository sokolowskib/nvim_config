-- Pomocniki edycji: podświetlanie TODO, szablony nowych plików, auto-nawiasy, surround.
-- Brak własnych keymapów; surround daje ys/cs/ds (n) i S (v), szczegóły w README.
-- Zależy od: todo-comments.nvim (+ plenary), skel-nvim (szablony w skeleton/), pear-tree, vim-surround.

-- podświetla TODO/FIXME/HACK/NOTE w komentarzach; lista: <leader>fd
require "todo-comments".setup({})

-- nowy pusty plik o pasującej nazwie dostaje treść z skeleton/<plik>.skel
require "skel-nvim".setup({
	mappings = {
		['*.cpp'] = "cpp.skel",
		['*.hpp'] = "hpp.skel",
		['*.c'] = 'c.skel',
		['Makefile'] = 'make.skel',
	}
})

-- pear-tree: automatyczne domykanie nawiasów i cudzysłowów
vim.g.pear_tree_repeatable_expand = 0
