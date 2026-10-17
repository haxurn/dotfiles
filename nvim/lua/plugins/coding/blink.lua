-- blink.cmp: fast autocomplete
-- Tab = accept/next, Shift-Tab = prev, Ctrl-Space = open, Ctrl-e = hide
return {
	"saghen/blink.cmp",
	version = "1.*", -- prebuilt fuzzy binary from the release
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = function()
		return {
			keymap = { preset = "super-tab" },

			appearance = {
				nerd_font_variant = "mono",
				kind_icons = vim.tbl_map(vim.trim, require("config.icons").kinds),
			},

			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				menu = {
					border = "rounded",
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
					},
				},
				ghost_text = { enabled = true }, -- inline preview of selection
			},

			signature = { enabled = true, window = { border = "rounded" } },

			cmdline = { enabled = true, completion = { menu = { auto_show = true } } },

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					-- neovim lua API completion, only in lua files
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		}
	end,
}
