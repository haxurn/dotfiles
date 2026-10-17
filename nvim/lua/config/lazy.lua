-- lazy.nvim bootstrap. Every file under lua/plugins/<group>/ returns a spec;
-- adding a plugin = dropping a file in the right group, nothing to register.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		"git", "clone", "--filter=blob:none", "--branch=stable",
		"https://github.com/folke/lazy.nvim.git", lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({ { "failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
		return
	end
end
vim.opt.rtp:prepend(lazypath)

local icons = require("config.icons")

require("lazy").setup({
	spec = {
		{ import = "plugins.ui" },
		{ import = "plugins.editor" },
		{ import = "plugins.coding" },
		{ import = "plugins.lsp" },
		{ import = "plugins.git" },
		{ import = "plugins.tools" },
	},
	defaults = { lazy = true }, -- load on event/cmd/keys/ft unless a spec says lazy = false
	install = { colorscheme = { "catppuccin", "gruvbox", "habamax" } },
	checker = { enabled = true, notify = false }, -- check for updates quietly; see :Lazy
	change_detection = { notify = false },
	rocks = { enabled = false }, -- no plugin here needs luarocks
	ui = {
		border = "rounded",
		icons = {
			cmd = icons.ui.terminal .. " ",
			config = icons.ui.gear .. " ",
			event = icons.ui.bolt .. " ",
			ft = icons.ui.file .. " ",
			keys = icons.ui.keyboard .. " ",
			plugin = icons.ui.plugin .. " ",
			start = icons.ui.bolt .. " ",
			source = icons.ui.code .. " ",
			lazy = icons.ui.sleep .. " ",
		},
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin",
			},
		},
	},
})
