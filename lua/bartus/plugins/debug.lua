-- Debugowanie (nvim-dap + dap-ui): C/C++ przez codelldb, C# przez netcoredbg.
-- Skróty: <F5> <F9> <F11> <F12>, <leader>b (breakpoint), <leader>d (debug/.NET) → dr.
-- Zależy od: nvim-dap, nvim-dap-ui, nvim-nio, netcoredbg-macOS-arm64.nvim, codelldb z masona.

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require('netcoredbg-macOS-arm64').setup(require('dap'))

-- dap-ui otwiera się sam po starcie sesji; zamykanie: :lua require('dapui').close()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
-- Keymaps
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: uruchom / kontynuuj' })
vim.keymap.set('n', '<F9>', dap.step_over, { desc = 'Debug: następna linia (step over)' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: wejdź do funkcji (step into)' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: wyjdź z funkcji (step out)' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: przełącz breakpoint' })

-- === C# === (adapter coreclr ustawia netcoredbg-macOS-arm64 powyżej)
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

-- .NET: wkleja do .csproj blok <Reference> dla wskazanego DLL
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
end, { desc = 'Wstaw referencję DLL do .csproj' })
