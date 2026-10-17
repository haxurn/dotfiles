-- merge conflicts: highlight markers and resolve with co / ct / cb / c0, ]x [x to jump
return {
	"akinsho/git-conflict.nvim",
	version = "*",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		default_mappings = true, -- co ours, ct theirs, cb both, c0 none, ]x [x next/prev
		disable_diagnostics = true, -- LSP noise inside conflict markers is useless
	},
	keys = {
		{ "<leader>hx", "<cmd>GitConflictListQf<CR>", desc = "conflicts to quickfix" },
	},
}
