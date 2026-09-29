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
