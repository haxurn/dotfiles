-- undo history as a tree (<leader>u)
return {
	"mbbill/undotree",
	cmd = "UndotreeToggle",
	keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "undotree" } },
	init = function()
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_WindowLayout = 2
	end,
}
