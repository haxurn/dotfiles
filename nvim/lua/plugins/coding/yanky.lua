-- yank ring: after `p`, cycle older yanks with <C-p>/<C-n>; <leader>Fy picks from history
return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	opts = {
		highlight = { timer = 200 },
		ring = { storage = "shada" },
	},
	keys = {
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "yank" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "put after" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "put before" },
		{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "older yank" },
		{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "newer yank" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "put line below" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "put line above" },
		{ "<leader>Fy", function() require("fzf-lua").registers() end, desc = "registers / yanks" },
	},
}
