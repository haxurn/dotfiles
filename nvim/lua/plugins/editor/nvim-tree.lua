-- file explorer sidebar (<leader>t). Not lazy: it must hijack `nvim .` before VimEnter.
-- per-language colored file icons come from nvim-web-devicons; folders/git use config/icons.lua.
return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>t", "<cmd>NvimTreeToggle<CR>", desc = "file tree" },
		{ "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "reveal file in tree" },
	},
	opts = function()
		local icons = require("config.icons")
		return {
			hijack_netrw = true, -- replace netrw
			hijack_directories = { enable = true, auto_open = true }, -- `nvim .` opens the tree
			diagnostics = {
				enable = true, -- LSP error badges on files/dirs
				show_on_dirs = true,
				icons = {
					error = icons.diagnostics.Error,
					warning = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			modified = { enable = true }, -- mark unsaved files
			renderer = {
				group_empty = true, -- collapse single-child dirs (a/b/c -> a/b/c)
				highlight_git = "name", -- color names by git status
				highlight_opened_files = "name",
				root_folder_label = ":t", -- show only the basename as root
				indent_markers = { enable = true },
				icons = {
					web_devicons = {
						file = { enable = true, color = true },
						folder = { enable = false, color = true },
					},
					git_placement = "after",
					modified_placement = "after",
					show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
					glyphs = {
						default = icons.ui.file,
						symlink = icons.ui.file,
						modified = icons.ui.modified,
						folder = {
							arrow_closed = icons.ui.arrow_closed,
							arrow_open = icons.ui.arrow_open,
							default = icons.ui.folder,
							open = icons.ui.folder_open,
							empty = icons.ui.folder_empty,
							empty_open = icons.ui.folder_empty_open,
							symlink = icons.ui.folder_symlink,
							symlink_open = icons.ui.folder_open,
						},
						git = {
							unstaged = vim.trim(icons.git.modified),
							staged = vim.trim(icons.git.staged),
							unmerged = vim.trim(icons.git.conflict),
							renamed = vim.trim(icons.git.renamed),
							untracked = vim.trim(icons.git.untracked),
							deleted = vim.trim(icons.git.removed),
							ignored = vim.trim(icons.git.ignored),
						},
					},
				},
			},
			view = { width = 32, side = "left" },
			sync_root_with_cwd = true, --fix to open cwd with tree
			respect_buf_cwd = true,
			update_focused_file = { enable = true, update_root = true },
		}
	end,
	config = function(_, opts)
		require("nvim-tree").setup(opts)
		-- `nvim .` / `nvim <dir>`: cd into it and open the tree instead of netrw
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function(data)
				if vim.fn.isdirectory(data.file) == 1 then
					vim.cmd.cd(data.file)
					require("nvim-tree.api").tree.open()
				end
			end,
		})
		-- use g? for bindings help while in tree
	end,
}
