-- oil: edit a directory like a buffer (rename/move/delete by editing lines, then :w)
-- `-` opens the parent dir of the current file. nvim-tree stays the `nvim .` explorer.
return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "-", "<cmd>Oil<CR>", desc = "oil: parent dir" },
		{ "<leader>-", function() require("oil").toggle_float() end, desc = "oil: float" },
	},
	opts = {
		default_file_explorer = false, -- nvim-tree owns directory buffers
		columns = { "icon", "permissions", "size" },
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = { show_hidden = true },
		float = { padding = 4, border = "rounded" },
		keymaps = {
			["q"] = "actions.close",
			["<C-h>"] = false, -- keep window navigation
			["<C-l>"] = false,
			["<C-r>"] = "actions.refresh",
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		-- tell LSP servers about renames done in oil (imports get updated)
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(ev)
				if ev.data.actions[1] and ev.data.actions[1].type == "move" then
					Snacks.rename.on_rename_file(ev.data.actions[1].src_url, ev.data.actions[1].dest_url)
				end
			end,
		})
	end,
}
