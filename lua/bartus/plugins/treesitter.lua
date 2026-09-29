-- Treesitter: podświetlanie, rozszerzanie zaznaczenia, textobjecty i skoki po funkcjach/klasach.
-- Skróty bez <leader>: af/if/ac/ic/aa/ia (x, o), ]f [f ]c [c, <C-space>/<BS> (zaznaczenie).
-- Zależy od: nvim-treesitter (gałąź master, API .configs), nvim-treesitter-textobjects (API main).

require "nvim-treesitter.configs".setup({
	highlight = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",   -- n: zacznij zaznaczać węzeł
			node_incremental = "<C-space>", -- v: rozszerz do rodzica
			node_decremental = "<BS>",      -- v: cofnij rozszerzenie
		},
	},
})
require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		include_surrounding_whitespace = false,
	},
})

-- textobjecty: vaf, dif, cia, yac…
local select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function()
	select.select_textobject("@function.outer", "textobjects")
end, { desc = 'Zaznacz całą funkcję' })
vim.keymap.set({ "x", "o" }, "if", function()
	select.select_textobject("@function.inner", "textobjects")
end, { desc = 'Zaznacz ciało funkcji' })
vim.keymap.set({ "x", "o" }, "ac", function()
	select.select_textobject("@class.outer", "textobjects")
end, { desc = 'Zaznacz całą klasę' })
vim.keymap.set({ "x", "o" }, "ic", function()
	select.select_textobject("@class.inner", "textobjects")
end, { desc = 'Zaznacz ciało klasy' })
vim.keymap.set({ "x", "o" }, "aa", function()
	select.select_textobject("@parameter.outer", "textobjects")
end, { desc = 'Zaznacz parametr z przecinkiem' })
vim.keymap.set({ "x", "o" }, "ia", function()
	select.select_textobject("@parameter.inner", "textobjects")
end, { desc = 'Zaznacz parametr' })

-- skoki między funkcjami/klasami
local move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]f", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = 'Przejdź do następnej funkcji' })
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = 'Przejdź do poprzedniej funkcji' })
vim.keymap.set({ "n", "x", "o" }, "]c", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = 'Przejdź do następnej klasy' })
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = 'Przejdź do poprzedniej klasy' })
