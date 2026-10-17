-- buffer tabs along the top (buffer keys live in lua/config/mappings.lua)
return {
	"romgrk/barbar.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
	init = function() vim.g.barbar_auto_setup = false end,
	opts = function()
		local icons = require("config.icons")
		local sev = vim.diagnostic.severity
		return {
			animation = false,
			tabpages = true, -- current/total tabpages indicator (top right corner)
			focus_on_close = "left",
			hide = { extensions = false, inactive = false },
			icons = {
				buffer_index = false,
				buffer_number = false,
				button = icons.ui.close,
				diagnostics = {
					[sev.ERROR] = { enabled = true, icon = icons.diagnostics.Error },
					[sev.WARN] = { enabled = true, icon = icons.diagnostics.Warn },
				},
				gitsigns = {
					added = { enabled = true, icon = icons.git.added },
					changed = { enabled = true, icon = icons.git.modified },
					deleted = { enabled = true, icon = icons.git.removed },
				},
				separator = { left = "▎", right = "" },
				separator_at_end = true,
				modified = { button = icons.ui.modified },
				pinned = { button = icons.ui.pin, filename = true },
				alternate = { filetype = { enabled = false } },
				current = { buffer_index = true },
				inactive = { button = "×" },
				visible = { modified = { buffer_number = false } },
			},
			sidebar_filetypes = { -- barbar offsets itself for these
				NvimTree = true,
				undotree = { text = "undotree", align = "left" },
				["dapui_scopes"] = { text = "debugger", align = "left" },
				NeogitStatus = { text = "neogit", align = "left" },
				DiffviewFiles = { text = "diffview", align = "left" },
			},
			maximum_length = 25,
		}
	end,
}
