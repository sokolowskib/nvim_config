-- Formatowanie kodu (conform): automatycznie przy zapisie i ręcznie.
-- Prefiks: <leader>c (code) → <leader>cf.
-- Zależy od: conform.nvim; formattery (clang-format, black) instaluje mason.
-- Gdy dla filetype nie ma formattera, conform używa formatowania z LSP.

require "conform".setup({
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		cs = { "clang-format" },
		python = { "black" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
	require('conform').format({
		lsp_format = "fallback",
		async = false,
		timeout_ms = 500,
	})
end, { desc = 'Sformatuj plik lub zaznaczenie' })
