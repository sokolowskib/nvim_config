-- LSP: instalacja serwerów (mason), włączenie serwerów i skróty dla akcji na kodzie.
-- Prefiks: <leader>c (code) → ca, cr. Domyślne mapy Neovima: K, grn, gra, grr, gri, gO, ]d [d.
-- Zależy od: mason.nvim, nvim-lspconfig (gotowe konfiguracje), roslyn.nvim (C#), blink.cmp.
-- Własne ustawienia serwera: lsp/<nazwa>.lua (np. lsp/roslyn.lua), łączone z lspconfig.

require "mason".setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry", -- tu jest roslyn dla C#
	},
})

vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Zmień nazwę symbolu w projekcie' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Pokaż akcje kodu' })

-- serwery językowe; nazwy jak pliki w nvim-lspconfig/lsp/ (roslyn: z roslyn.nvim)
vim.lsp.enable({ 'roslyn', 'pyright', 'clangd', 'lua_ls', 'emmet_ls', 'html', 'cssls', 'air', 'rust_analyzer' })
vim.lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities({
		textDocument = {
			hover = { contentFormat = { "markdown", "plaintext" } },
		},
	}),
})
