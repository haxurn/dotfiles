-- inline "error lens": shows the diagnostic message next to the offending line
return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "modern",
			options = {
				show_source = { enabled = true, if_many = true },
				use_icons_from_diagnostic = true,
				multilines = { enabled = true, always_show = false },
				show_all_diags_on_cursorline = false,
				enable_on_insert = false,
			},
		})

		-- this plugin owns virtual text; make sure core diagnostics don't double-draw
		vim.diagnostic.config({ virtual_text = false })
	end,
}
