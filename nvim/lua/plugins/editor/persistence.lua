-- sessions: saved per directory (and per git branch) on exit, restored on demand
return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- start recording once a real file is opened
	opts = { branch = true },
	keys = {
		{ "<leader>Ss", function() require("persistence").load() end, desc = "restore session (cwd)" },
		{ "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "restore last session" },
		{ "<leader>SS", function() require("persistence").select() end, desc = "pick session" },
		{ "<leader>Sd", function() require("persistence").stop() end, desc = "don't save this session" },
	},
}
