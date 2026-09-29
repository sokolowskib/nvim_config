require "conform".setup({
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		cs = { "clang-format" },
		python = { "black" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,

	},
})
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
	require('conform').format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = 'Format file or range' })
