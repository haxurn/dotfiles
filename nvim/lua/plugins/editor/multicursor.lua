-- multiple cursors. Add cursors, edit normally, <Esc> to collapse back to one.
--   <leader>mn / mN  add cursor at next / prev match of word or selection
--   <leader>mj / mk  add cursor on line below / above
--   <leader>mA       cursor on every match      <leader>ms  skip next match
--   <C-LeftMouse>    add/remove cursor by clicking
return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	keys = {
		{ "<leader>mn", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" }, desc = "cursor at next match" },
		{ "<leader>mN", function() require("multicursor-nvim").matchAddCursor(-1) end, mode = { "n", "x" }, desc = "cursor at prev match" },
		{ "<leader>ms", function() require("multicursor-nvim").matchSkipCursor(1) end, mode = { "n", "x" }, desc = "skip next match" },
		{ "<leader>mA", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "x" }, desc = "cursor at every match" },
		{ "<leader>mj", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "x" }, desc = "cursor below" },
		{ "<leader>mk", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "x" }, desc = "cursor above" },
		{ "<C-LeftMouse>", function() require("multicursor-nvim").handleMouse() end, desc = "toggle cursor" },
	},
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()
		-- these only apply while more than one cursor exists
		mc.addKeymapLayer(function(layer)
			layer({ "n", "x" }, "<Left>", mc.prevCursor)
			layer({ "n", "x" }, "<Right>", mc.nextCursor)
			layer({ "n", "x" }, "<leader>mx", mc.deleteCursor)
			layer("n", "<Esc>", function()
				if not mc.cursorsEnabled() then mc.enableCursors() else mc.clearCursors() end
			end)
		end)
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
