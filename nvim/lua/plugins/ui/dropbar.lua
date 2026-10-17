-- breadcrumbs in the winbar: path > class > function, clickable / pickable
return {
	"Bekaboo/dropbar.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local icons = require("config.icons")
		return {
			icons = {
				kinds = { symbols = icons.kinds },
				ui = { bar = { separator = " " .. icons.ui.arrow_closed .. " " } },
			},
		}
	end,
	keys = {
		{ "<leader>;", function() require("dropbar.api").pick() end, desc = "pick breadcrumb" },
	},
}
