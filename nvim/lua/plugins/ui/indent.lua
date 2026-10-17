-- indent guides with the current scope highlighted, plus rainbow brackets
return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "│", tab_char = "│" },
			scope = { enabled = true, show_start = false, show_end = false },
			exclude = {
				filetypes = {
					"help", "alpha", "NvimTree", "fterm_btop", "fterm_lazygit",
					"Trouble", "trouble", "mason", "lazy", "markdown", "fzf", "oil",
					"notify", "noice", "dapui_scopes", "dapui_breakpoints", "dapui_stacks",
					"dapui_watches", "neotest-summary",
				},
			},
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		submodules = false,
	},
}
