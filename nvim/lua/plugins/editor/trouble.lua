-- trouble: a clean list view for diagnostics / symbols / todos
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	event = "VeryLazy",
	config = function()
		-- trouble: a clean list view for diagnostics / symbols / todos
		require("trouble").setup({ focus = true })

		local function map(k, cmd, desc)
			vim.keymap.set("n", k, cmd, { silent = true, desc = desc })
		end

		-- headline: quick toggle of all errors/warnings
		map("<leader>T", "<cmd>Trouble diagnostics toggle<CR>", "diagnostics list")
		-- <leader>X group (capital X; lowercase x is chmod +x)
		map("<leader>Xx", "<cmd>Trouble diagnostics toggle<CR>", "diagnostics (all)")
		map("<leader>Xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "diagnostics (buffer)")
		map("<leader>Xs", "<cmd>Trouble symbols toggle<CR>", "symbols outline")
		map("<leader>Xl", "<cmd>Trouble loclist toggle<CR>", "location list")
		map("<leader>Xq", "<cmd>Trouble qflist toggle<CR>", "quickfix list")
		map("<leader>Xt", "<cmd>Trouble todo toggle<CR>", "todo list")
	end,
}
