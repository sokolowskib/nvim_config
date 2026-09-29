-- Autokomendy: powrót do ostatniej pozycji w pliku, podświetlenie skopiowanego tekstu.
-- Brak keymapów. Zależy tylko od wbudowanego API Neovima.

vim.api.nvim_create_autocmd('BufReadPost', {
	group = vim.api.nvim_create_augroup('bartus/last_location', { clear = true }),
	desc = 'Go to the last location when opening a buffer',
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd 'normal! g`"zz'
		end
	end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})
