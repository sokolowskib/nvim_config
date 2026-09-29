return {
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
}
