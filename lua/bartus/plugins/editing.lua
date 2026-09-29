--TODO
require "todo-comments".setup({
	dependencies = { "nvim-lua/plenary.nvim" },
})

require "skel-nvim".setup({
	mappings = {
		['*.cpp'] = "cpp.skel",
		['*.hpp'] = "hpp.skel",
		['*.c'] = 'c.skel',
		['Makefile'] = 'make.skel',
	}
})

vim.g.pear_tree_repeatable_expand = 0
