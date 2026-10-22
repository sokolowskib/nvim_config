-- Podgląd Markdowna w przeglądarce (markdown-preview.nvim), odświeżany na żywo.
-- Skróty: <leader>mp (przełącz podgląd), tylko w plikach markdown.
-- Zależy od: markdown-preview.nvim (binarka w app/bin/, pobierana hookiem w pack.lua).

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(ev)
		vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>",
			{ buffer = ev.buf, desc = "Podgląd Markdowna w przeglądarce" })
	end,
})
