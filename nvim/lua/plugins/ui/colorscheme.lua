-- colorschemes. Only catppuccin loads at startup (the fallback); the rest load
-- when :colorscheme asks for them. Cycle with <leader>p (lua/config/theme.lua).
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "frappe",
			transparent_background = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			integrations = {
				alpha = true,
				barbar = true,
				blink_cmp = true,
				dap = true,
				dap_ui = true,
				diffview = true,
				dropbar = { enabled = true, color_mode = true },
				fidget = true,
				flash = true,
				gitsigns = true,
				harpoon = true,
				indent_blankline = { enabled = true, scope_color = "lavender", colored_indent_levels = false },
				mason = true,
				native_lsp = { enabled = true },
				neogit = true,
				neotest = true,
				noice = true,
				notify = true,
				nvimtree = true,
				rainbow_delimiters = true,
				render_markdown = true,
				treesitter_context = true,
				which_key = true,
			},
		},
		config = function(_, opts) require("catppuccin").setup(opts) end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		opts = {
			terminal_colors = true,
			italic = { strings = true, emphasis = true, comments = true, operators = false, folds = true },
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			transparent_mode = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "night",
			transparent = true,
			styles = { sidebars = "transparent", floats = "transparent" },
		},
	},
	{
		"rebelot/kanagawa.nvim",
		opts = { transparent = true, theme = "wave" },
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		opts = { styles = { transparency = true } },
	},
	{ "uZer/pywal16.nvim", name = "pywal16" },
}
