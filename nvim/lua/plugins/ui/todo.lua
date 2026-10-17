-- highlight + search TODO: FIX: HACK: NOTE: WARN: PERF: comments
return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = true },
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "next todo" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "prev todo" },
		{ "<leader>Ft", "<cmd>TodoFzfLua<CR>", desc = "todos" },
	},
}
