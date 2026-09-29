require("blink.cmp").setup({
	sources = {
		default = { 'lsp', 'path', 'buffer', 'snippets' },
	},
	fuzzy = {
		implementation = "lua",
		prebuilt_binaries = {
			force_version = "v1.7.6"
		}
	},

	keymap = {
		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-e>'] = { 'hide' },
		['<C-y>'] = { 'select_and_accept' },
		['<CR>'] = { 'accept', 'fallback' },
		['<Tab>'] = { 'select_next', 'fallback' },
		['<S-Tab>'] = { 'select_prev', 'fallback' },
		['<C-n>'] = { 'select_next', 'fallback' },
		['<C-p>'] = { 'select_prev', 'fallback' },
	},
	completion = {
		ghost_text = {
			enabled = true,
		}
	},
	signature = {
		enabled = true,
		window = {
			border = "rounded",
			show_documentation = false, -- just signature, no big doc panel
		},
	},
})

-- poczatek szpatu
vim.keymap.set('i', '<Tab>', function()
	-- First check if blink.cmp has an active completion menu
	local blink = require('blink.cmp')
	if blink.is_visible() then
		return blink.accept()
	end

	-- Then check if we're in a snippet
	if vim.snippet and vim.snippet.active({ direction = 1 }) then
		vim.snippet.jump(1)
		return
	end

	-- Check if cursor is before a closing bracket/quote
	local col = vim.fn.col('.') - 1
	local line = vim.fn.getline('.')
	local char = line:sub(col + 1, col + 1)

	if char:match('[%)%]%}"\']') then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Right>', true, false, true), 'n', false)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
	end
end, { desc = "Smart Tab" })

vim.keymap.set('i', '<S-Tab>', function()
	-- Check if blink.cmp has an active completion menu
	local blink = require('blink.cmp')
	if blink.is_visible() then
		return blink.select_prev()
	end

	-- Then check if we're in a snippet
	if vim.snippet and vim.snippet.active({ direction = -1 }) then
		vim.snippet.jump(-1)
		return
	end

	-- Otherwise, just do a regular Shift-Tab
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true), 'n', false)
end, { desc = "Smart Shift-Tab" })
