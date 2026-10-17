-- neogit: magit-style git UI inside nvim (stage, commit, push, rebase from a buffer)
-- lazygit is still on <leader>hg for the full TUI.
return {
	"NeogitOrg/neogit",
	cmd = "Neogit",
	dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "ibhagwan/fzf-lua" },
	keys = {
		{ "<leader>hn", "<cmd>Neogit<CR>", desc = "neogit status" },
		{ "<leader>hc", "<cmd>Neogit commit<CR>", desc = "neogit commit" },
		{ "<leader>hl", "<cmd>Neogit log<CR>", desc = "neogit log" },
	},
	opts = function()
		local i = require("config.icons").ui
		return {
			kind = "tab",
			graph_style = "unicode",
			integrations = { diffview = true, fzf_lua = true },
			signs = {
				section = { i.arrow_closed, i.arrow_open },
				item = { i.arrow_closed, i.arrow_open },
			},
		}
	end,
}
