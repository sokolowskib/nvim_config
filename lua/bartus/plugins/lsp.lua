require "mason".setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = "rename in project" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "code actions" })

--servery jezykowe
vim.lsp.enable({ 'roslyn', 'pyright', 'clangd', 'lua_ls', 'emmet_ls', 'html', 'cssls', 'air', 'rust_analyzer' })
vim.lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities({
		textDocument = {
			hover = { contentFormat = { "markdown", "plaintext" } },
		},
	}),
})
