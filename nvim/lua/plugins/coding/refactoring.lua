-- refactoring.nvim: extract / inline function and variable, debug prints.
-- The maps are operators: in normal mode follow with a motion or text object
-- (<leader>rv + iw, <leader>rf + af), in visual mode they act on the selection.
local function r(fn, suffix)
	return function() return require("refactoring")[fn]() .. (suffix or "") end
end
local function dbg(fn, opts, suffix)
	return function() return require("refactoring.debug")[fn](opts) .. (suffix or "") end
end

return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = { "lewis6991/async.nvim" }, -- only needed on nvim 0.12
	keys = {
		{ "<leader>rf", r("extract_func"), mode = { "n", "x" }, expr = true, desc = "extract function" },
		{ "<leader>rF", r("extract_func_to_file"), mode = { "n", "x" }, expr = true, desc = "extract function to file" },
		{ "<leader>rv", r("extract_var"), mode = { "n", "x" }, expr = true, desc = "extract variable" },
		{ "<leader>ri", r("inline_var"), mode = { "n", "x" }, expr = true, desc = "inline variable" },
		{ "<leader>rI", r("inline_func"), mode = { "n", "x" }, expr = true, desc = "inline function" },
		{ "<leader>rs", r("select_refactor"), mode = { "n", "x" }, expr = true, desc = "pick refactor" },
		{ "<leader>rp", dbg("print_var", { output_location = "below" }, "iw"), expr = true, desc = "debug print word" },
		{ "<leader>rp", dbg("print_var", { output_location = "below" }), mode = "x", expr = true, desc = "debug print selection" },
		{ "<leader>rl", dbg("print_loc", { output_location = "below" }), expr = true, desc = "debug print location" },
		-- `ig` = whole buffer (mini.ai custom object in coding/textobjects.lua)
		{ "<leader>rc", dbg("cleanup", { restore_view = true }, "ig"), expr = true, remap = true, desc = "clean debug prints" },
	},
}
