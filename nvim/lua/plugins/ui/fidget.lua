-- LSP progress + work-done spinner in the corner
return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		progress = {
			display = { done_icon = "✓" },
		},
		notification = {
			window = { winblend = 0 },
		},
	},
}
