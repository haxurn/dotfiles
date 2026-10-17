-- snacks: small quality-of-life modules (only the ones enabled here run)
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true }, -- drop heavy features on huge files
		quickfile = { enabled = true }, -- render `nvim file` before plugins load
		input = { enabled = true }, -- nicer vim.ui.input (rename, etc.)
		scroll = { enabled = true }, -- smooth scrolling
		words = { enabled = true }, -- highlight LSP references of the word under cursor
		statuscolumn = { enabled = true }, -- signs, folds, git in one tidy column
		toggle = { enabled = true },
		rename = { enabled = true }, -- LSP-aware file rename (used by oil)
		zen = { enabled = true },
		dim = { enabled = true },
		styles = { input = { relative = "cursor", row = -3, col = 0 } },
	},
	keys = {
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "next reference" },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "prev reference" },
		{ "<leader>Z", function() Snacks.zen() end, desc = "zen mode" },
		{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "rename file (LSP-aware)" },
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- <leader>O* toggles; which-key shows their on/off state
				Snacks.toggle.option("spell", { name = "spelling" }):map("<leader>Os")
				Snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>Ow")
				Snacks.toggle.diagnostics():map("<leader>Od")
				Snacks.toggle.inlay_hints():map("<leader>Oh")
				Snacks.toggle.treesitter():map("<leader>OT")
				Snacks.toggle.option("conceallevel", { off = 0, on = 2 }):map("<leader>Oc")
				Snacks.toggle.dim():map("<leader>OD")
				Snacks.toggle({
					name = "format on save",
					get = function() return vim.g.autoformat end,
					set = function(state) vim.g.autoformat = state end,
				}):map("<leader>Of")
			end,
		})
	end,
}
