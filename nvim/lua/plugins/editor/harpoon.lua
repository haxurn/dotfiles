-- harpoon: pin a handful of files per project and jump to them by number
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { settings = { save_on_toggle = true } },
	keys = function()
		local keys = {
			{ "<leader>aa", function() require("harpoon"):list():add() end, desc = "harpoon file" },
			{ "<leader>al", function()
				local h = require("harpoon")
				h.ui:toggle_quick_menu(h:list(), { border = "rounded", title_pos = "center" })
			end, desc = "harpoon menu" },
			{ "<leader>an", function() require("harpoon"):list():next() end, desc = "harpoon next" },
			{ "<leader>ap", function() require("harpoon"):list():prev() end, desc = "harpoon prev" },
		}
		for i = 1, 5 do
			table.insert(keys, {
				"<leader>" .. i,
				function() require("harpoon"):list():select(i) end,
				desc = "harpoon " .. i,
			})
		end
		return keys
	end,
}
