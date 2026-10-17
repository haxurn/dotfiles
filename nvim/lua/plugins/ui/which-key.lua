-- key hint popup (press <leader> and wait). Groups get icons from config/icons.lua.
-- Maps defined with a `desc` show up on their own; only bare maps are named here.
return {
	{
		"nvim-tree/nvim-web-devicons",
		opts = { color_icons = true, default = true },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = function()
			local i = require("config.icons").ui
			local function group(lhs, name, icon, color)
				return { lhs, group = name, icon = { icon = icon, color = color } }
			end
			return {
				preset = "helix",
				delay = 300,
				win = { border = "rounded" },
				spec = {
					-- groups
					group("<leader>c", "code / lsp", i.code, "azure"),
					group("<leader>cs", "csv", i.csv, "green"),
					group("<leader>h", "git", i.git, "orange"),
					group("<leader>X", "trouble lists", i.list, "red"),
					group("<leader>F", "fzf pickers", i.search, "cyan"),
					group("<leader>O", "toggles", i.toggle, "yellow"),
					group("<leader>S", "sessions", i.session, "purple"),
					group("<leader>a", "harpoon", i.harpoon, "cyan"),
					group("<leader>D", "debug", i.bug, "red"),
					group("<leader>j", "tests", i.test, "green"),
					group("<leader>m", "multicursor", i.cursor, "purple"),
					group("<leader>N", "notifications", i.notes, "blue"),
					group("<leader>r", "refactor / rename", i.fix, "azure"),
					group("<leader>n", "numbers", i.list, "grey"),
					group("<leader>v", "splits", i.window, "grey"),

					-- maps from config/mappings.lua without a desc
					{ "<leader>d", desc = "duplicate file" },
					{ "<leader>p", desc = "cycle theme", icon = i.palette },
					{ "<leader>P", desc = "plugins (lazy)", icon = i.plugin },
					{ "<leader>x", desc = "chmod +x" },
					{ "<leader>t", desc = "file tree", icon = i.tree },
					{ "<leader>R", desc = "source file" },
					{ "<leader>vs", desc = "vsplit next buf" },
					{ "<leader>w", desc = "write" },
					{ "<leader>W", desc = "toggle wrap" },
					{ "<leader>T", desc = "diagnostics list", icon = i.list },
					{ "<leader>q", desc = "close buf" },
					{ "<leader>Q", desc = "close buf!" },
					{ "<leader>U", desc = "close ALL buf" },
					{ "<leader>nn", desc = "toggle relative nums" },
					{ "<leader>s", desc = "replace all" },
					{ "<leader>mv", desc = "move file" },
					{ "<leader>csa", desc = "align csv" },
					{ "<leader>csA", desc = "clear csv align" },
				},
			}
		end,
		keys = {
			{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "buffer keymaps" },
		},
	},
}
