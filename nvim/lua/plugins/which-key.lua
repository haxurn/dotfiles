local wk = require("which-key")
wk.add({
	-- groups
	{ "<leader>c", group = "code / lsp" },
	{ "<leader>h", group = "git hunks" },
	{ "<leader>X", group = "trouble lists" },
	{ "<leader>F", group = "fzf opts" },
	{ "<leader>cs", group = "csv" },

	-- files / misc
	{ "<leader>d", desc = "duplicate file" },
	{ "<leader>p", desc = "toggle theme" },
	{ "<leader>u", desc = "undotree" },
	{ "<leader>z", desc = "floating terminal" },
	{ "<leader>f", desc = "fzf files" },
	{ "<leader>b", desc = "fzf buffers" },
	{ "<leader>o", desc = "fzf recent files" },
	{ "<leader>g", desc = "grep" },
	{ "<leader>G", desc = "grep under cursor" },
	{ "<leader>x", desc = "chmod +x" },
	{ "<leader>t", desc = "file tree" },
	{ "<leader>R", desc = "reload config" },
	{ "<leader>vs", desc = "vsplit next buf" },
	{ "<leader>w", desc = "write" },
	{ "<leader>W", desc = "toggle wrap" },
	{ "<leader>q", desc = "close buf" },
	{ "<leader>Q", desc = "close buf!" },
	{ "<leader>U", desc = "close ALL buf" },
	{ "<leader>nn", desc = "toggle relative nums" },
	{ "<leader>H", desc = "btop" },
	{ "<leader>l", desc = "twilight dim" },

	-- fzf extras
	{ "<leader>Fg", desc = "git status" },
	{ "<leader>Fs", desc = "document symbols" },
	{ "<leader>Fk", desc = "keymaps" },
	{ "<leader>Fd", desc = "diagnostics" },
	{ "<leader>Fr", desc = "resume last" },

	-- lsp / diagnostics / format
	{ "<leader>ca", desc = "code action" },
	{ "<leader>cf", desc = "format" },
	{ "<leader>cF", desc = "toggle format on save" },
	{ "<leader>ci", desc = "toggle inlay hints" },
	{ "<leader>rn", desc = "rename symbol" },
	{ "<leader>e", desc = "line diagnostics" },
	{ "<leader>T", desc = "diagnostics list" },

	-- git
	{ "<leader>hg", desc = "lazygit" },
	{ "<leader>hs", desc = "stage hunk" },
	{ "<leader>hr", desc = "reset hunk" },
	{ "<leader>hp", desc = "preview hunk" },
	{ "<leader>hb", desc = "blame line" },
	{ "<leader>hB", desc = "toggle inline blame" },
	{ "<leader>hd", desc = "diff this" },
})
