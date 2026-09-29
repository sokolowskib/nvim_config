require("which-key").setup({
	preset = "modern", -- or "classic" / "helix"
	delay = 300,
})

-- group names so the popup is readable
local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "find" },
	{ "<leader>t", group = "terminal/toggle" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug/dll" },
	{ "<leader>g", group = "goto" },
})

require("smear_cursor").setup({
	-- Ustawiamy kolor ogonka na domyślny, jasny kolor tekstu w Rose Pine.
	-- To powinno idealnie skleić się ze statycznym kursorem terminala.
	cursor_color = "#e0def4",

	smear_between_buffers = true,
	smear_between_neighbor_lines = true,
	scroll_buffer_space = true,
	legacy_computing_symbols_support = false,
	smear_insert_mode = true,
})
require("neoscroll").setup({
	hide_cursor = true,       -- Hide cursor while scrolling
	stop_eof = true,          -- Stop at <EOF> when scrolling downwards
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	duration_multiplier = 1.0, -- Global duration multiplier
	easing = 'linear',        -- Default easing function
	pre_hook = nil,           -- Function to run before the scrolling animation starts
	post_hook = nil,          -- Function to run after the scrolling animation ends
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
	ignored_events = {        -- Events ignored while scrolling
		'WinScrolled', 'CursorMoved'
	},
})

require "lualine".setup({})
require "catppuccin".setup({
	flavour = "mocha",
	transparent_background = false,
	term_colors = false,
})
require "tokyonight".setup({
	style = "night",
})
require("vague").setup({
	italic = false,
})
require("rose-pine").setup({
	variant = "moon",
	styles = {
		italic = false
	}
})
vim.cmd("colorscheme rose-pine")
vim.cmd(":hi statusline guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "#120f18" })
