-- Wygląd i podpowiedzi: which-key (grupy prefiksów), kolory, statusline, animacje kursora/scrolla.
-- Brak własnych keymapów; neoscroll animuje <C-u> <C-d> <C-b> <C-f> <C-y> <C-e> zz zt zb.
-- Zależy od: which-key.nvim, rose-pine, lualine.nvim, smear-cursor.nvim, neoscroll.nvim.

require("which-key").setup({
	preset = "modern", -- or "classic" / "helix"
	delay = 300,
})

-- nazwy grup w okienku which-key (po wciśnięciu <leader> i odczekaniu 300 ms)
local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "Szukaj (find)" },
	{ "<leader>t", group = "Terminal" },
	{ "<leader>c", group = "Kod i LSP" },
	{ "<leader>d", group = "Debug i .NET" },
	{ "<leader>g", group = "Przejdź do (goto)" },
	{ "<leader>j", group = "Jupyter (notebooki)" },
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

-- neoscroll zakłada mapy bez opisu; zakładamy je ponownie z tym samym callbackiem + desc
for key, desc in pairs({
	["<C-u>"] = "Przewiń pół ekranu w górę",
	["<C-d>"] = "Przewiń pół ekranu w dół",
	["<C-b>"] = "Przewiń ekran w górę",
	["<C-f>"] = "Przewiń ekran w dół",
	["<C-y>"] = "Przesuń widok w górę",
	["<C-e>"] = "Przesuń widok w dół",
	["zt"] = "Ustaw linię na górze ekranu",
	["zz"] = "Ustaw linię na środku ekranu",
	["zb"] = "Ustaw linię na dole ekranu",
}) do
	local callback = vim.fn.maparg(key, "n", false, true).callback
	vim.keymap.set({ "n", "v", "x" }, key, callback, { desc = desc })
end

require "lualine".setup({})

-- motyw kolorów + własne tło
require("rose-pine").setup({
	variant = "moon",
	styles = {
		italic = false
	}
})
vim.cmd("colorscheme rose-pine")
vim.cmd(":hi statusline guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "#120f18" })
