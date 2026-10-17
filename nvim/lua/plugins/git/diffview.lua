-- diffview: side-by-side diffs, file history, 3-way merge view
return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
	keys = {
		{ "<leader>hv", "<cmd>DiffviewOpen<CR>", desc = "diffview: working tree" },
		{ "<leader>hV", "<cmd>DiffviewClose<CR>", desc = "diffview: close" },
		{ "<leader>hf", "<cmd>DiffviewFileHistory %<CR>", desc = "file history" },
		{ "<leader>hF", "<cmd>DiffviewFileHistory<CR>", desc = "repo history" },
		{ "<leader>hm", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>", desc = "diff vs default branch" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = { merge_tool = { layout = "diff3_mixed" } },
	},
}
