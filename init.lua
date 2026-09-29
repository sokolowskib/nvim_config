vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.shiftwidth = 4
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>tt', ':below terminal<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
--vim.keymap.set('n', '<leader>cf', conform.format())
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', 'g[', vim.diagnostic.goto_next)
vim.keymap.set('n', 'g]', vim.diagnostic.goto_prev)
vim.o.termguicolors = true
vim.keymap.set('n', '<leader>ft', ':Oil<CR>')
vim.keymap.set({ "x", "o" }, "aq", 'a"')
vim.keymap.set({ "x", "o" }, "iq", 'i"')
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99 -- domyślnie wszystko rozwinięte
vim.o.foldlevelstart = 99
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/tmsvg/pear-tree" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/motosir/skel-nvim" },
	{ src = "https://github.com/seblyng/roslyn.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/Cliffback/netcoredbg-macOS-arm64.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/olimorris/codecompanion.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	{ src = "https://github.com/karb94/neoscroll.nvim" }

})
require "telescope".setup({})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope lsp references' })
vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = 'Telescope lsp definition' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search in current file' })


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
vim.api.nvim_create_autocmd('BufReadPost', {
	group = vim.api.nvim_create_augroup('mariasolos/last_location', { clear = true }),
	desc = 'Go to the last location when opening a buffer',
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd 'normal! g`"zz'
		end
	end,
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


--TODO
require "todo-comments".setup({
	dependencies = { "nvim-lua/plenary.nvim" },
})


vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = "rename in project" })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>fw', builtin.lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fd', ':TodoTelescope<CR>')

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		include_surrounding_whitespace = false,
	},
})
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})
-- textobject selections
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "aa", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end)

-- movement between functions/classes
local move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]f", function()
	move.goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	move.goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]c", function()
	move.goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	move.goto_previous_start("@class.outer", "textobjects")
end)
require "catppuccin".setup({
	flavour = "mocha",
	transparent_background = false,
	term_colors = false,
})
require "tokyonight".setup({
	style = "night",
})

vim.keymap.set('n', '<leader>v', ':vsplit<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<leader>tm', ':term<CR>')

vim.keymap.set('n', '<leader>,', ':vertical resize -2<CR>')
vim.keymap.set('n', '<leader>.', ':vertical resize +2<CR>')

vim.keymap.set('n', '<leader>tr', function()
	vim.cmd('botright vsplit | terminal')
	vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.25))
	vim.cmd('startinsert')
end, { desc = '25% terminal on right' })

require "lualine".setup({})
require "mason".setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
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
vim.diagnostic.config({
	virtual_text = true,
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require('netcoredbg-macOS-arm64').setup(require('dap'))

-- Auto open/close UI
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	--dapui.close()
end
-- Keymaps
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F9>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)

-- === LUA ===
dap.adapters["local-lua"] = {
	type = "executable",
	command = "node",
	args = {
		vim.fn.stdpath("data") .. "/debuggers/local-lua-debugger-vscode/extension/debugAdapter.js"
	},
	enrich_config = function(config, on_config)
		if not config["extensionPath"] then
			local c = vim.deepcopy(config)
			c.extensionPath = vim.fn.stdpath("data") .. "/debuggers/local-lua-debugger-vscode/"
			on_config(c)
		else
			on_config(config)
		end
	end,
}

dap.configurations.lua = {
	{
		type = "local-lua",
		request = "launch",
		name = "Debug current file",
		program = {
			lua = "lua",
			file = "${file}",
		},
	},
}

-- === C# ===
local mason_path = vim.fn.stdpath("data") ..
	"/site/pack/core/opt/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
dap.adapters.coreclr = {
	type = 'executable',
	command = mason_path,
	args = { '--interpreter=vscode' }
}

-- Basic launch configuration
dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			local cwd = vim.fn.getcwd()

			-- Search for DLL in bin/Debug
			local dll_pattern = cwd .. '/bin/Debug/net*/**.dll'
			local dlls = vim.fn.glob(dll_pattern, false, true)

			if #dlls > 0 then
				-- If multiple DLLs found, pick the one matching project name
				local project_name = vim.fn.fnamemodify(cwd, ':t')
				for _, dll in ipairs(dlls) do
					if dll:match(project_name) then
						return dll
					end
				end
				-- Otherwise return first DLL found
				return dlls[1]
			end

			-- Fallback to manual input if no DLL found
			return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
		end,
	},
}

-- === C/C++ ===
dap.adapters.codelldb = {
	type = 'server',
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
		args = { "--port", "${port}" },
	},
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			local cwd = vim.fn.getcwd()

			-- Search paths in order of priority
			local search_paths = {
				cwd .. '/build/main',
				cwd .. '/bin/main',
				cwd .. '/main',
			}

			-- Check each path
			for _, path in ipairs(search_paths) do
				if vim.fn.filereadable(path) == 1 then
					return path
				end
			end

			-- Fallback to manual input if 'main' not found
			return vim.fn.input('Path to executable: ', cwd .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = true,
		sourceLanguages = { "cpp", "c" },
	},
}

dap.configurations.c = dap.configurations.cpp

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
	require('conform').format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = 'Format file or range' })


require "skel-nvim".setup({
	mappings = {
		['*.cpp'] = "cpp.skel",
		['*.hpp'] = "hpp.skel",
		['*.c'] = 'c.skel',
		['Makefile'] = 'make.skel',
	}
})
require "nvim-treesitter.configs".setup({
	highlight = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			node_decremental = "<BS>",
		},
	},
})
require "mini.pick".setup()
require "oil".setup()
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

vim.g.pear_tree_repeatable_expand = 0

--vim.keymap.set('n', '<leader>ff', ':Pick files<CR>')
--vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
--vim.keymap.set('n', '<leader>fi', ":Pick grep<CR>")



require("vague").setup({
	italic = false,
})
require("rose-pine").setup({
	variant = "moon",
	styles = {
		italic = false
	}
})

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "code actions" })

--servery jezykowe
vim.lsp.enable({ "roslyn", 'omnisharp', 'pyright', 'clangd', 'lua_ls', 'harper-ls', 'emmet_ls', 'html',
	'htmlbeautifier', 'cssls', 'air', 'rust_analyzer' })
vim.lsp.config("roslyn", {
	on_attach = function()
		print("this will print when roslyn attaches")
	end,
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
		},
		["csharp|formatting"] = {
			indentation_size = 4,
			tab_size = 4,
			use_tabs = false,
		},
		["csharp|code_style"] = {
			indentation_size = 4,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
	}
})
vim.cmd("colorscheme rose-pine")
vim.cmd(":hi statusline guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "#120f18" })


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





-- do csproj wrzuca plik
vim.keymap.set('n', '<leader>dr', function()
	local dll = vim.fn.input('DLL path: ', '', 'file')
	if dll == '' then return end
	local name = vim.fn.fnamemodify(dll, ':t:r')
	local lines = {
		'  <ItemGroup>',
		'    <Reference Include="' .. name .. '">',
		'      <HintPath>' .. dll .. '</HintPath>',
		'    </Reference>',
		'  </ItemGroup>',
	}
	vim.api.nvim_put(lines, 'l', true, true)
end, { desc = 'Insert DLL reference' })


vim.lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities({
		textDocument = {
			hover = { contentFormat = { "markdown", "plaintext" } },
		},
	}),
})
