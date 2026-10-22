-- Hooki budowania (vim.pack nie ma `build` jak lazy.nvim): muszą być zdefiniowane
-- PRZED vim.pack.add, żeby złapać pierwszą instalację.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local d = ev.data
		if d.spec.name == "markdown-preview.nvim" and (d.kind == "install" or d.kind == "update") then
			-- pobiera gotową binarkę do app/bin/
			vim.system({ "./install.sh" }, { cwd = d.path .. "/app" })
		end
		if d.spec.name == "molten-nvim" and (d.kind == "install" or d.kind == "update") then
			-- remote plugin w Pythonie: rejestruje komendy w rplugin.vim. Komenda
			-- :UpdateRemotePlugins istnieje dopiero po starcie (VimEnter)
			local function register()
				vim.cmd.packadd("molten-nvim")
				vim.cmd("UpdateRemotePlugins")
			end
			if vim.v.vim_did_enter == 1 then
				register()
			else
				vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = register })
			end
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
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
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	{ src = "https://github.com/karb94/neoscroll.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
	{ src = "https://github.com/GCBallesteros/jupytext.nvim" },
	{ src = "https://github.com/benlubas/molten-nvim" },
	{ src = "https://github.com/3rd/image.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },

})
