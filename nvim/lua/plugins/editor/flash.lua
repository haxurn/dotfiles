-- flash.nvim: jump anywhere on screen with 1-2 label keystrokes
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	config = function()
		-- flash.nvim: jump anywhere on screen with 1-2 label keystrokes
		require("flash").setup({})

		local function fl(name)
			return function() require("flash")[name]() end
		end

		-- s = jump (normal/visual/operator). Note: overrides builtin `s` (substitute char);
		-- use `cl` if you ever need the old behaviour.
		vim.keymap.set({ "n", "x", "o" }, "s", fl("jump"), { silent = true, desc = "flash jump" })
		-- S = select an expanding treesitter node (kept out of visual mode so `S` there
		-- stays free for nvim-surround).
		vim.keymap.set({ "n", "o" }, "S", fl("treesitter"), { silent = true, desc = "flash treesitter" })
		-- in operator-pending: r = act on a remote location without moving (e.g. yrr<label>)
		vim.keymap.set("o", "r", fl("remote"), { silent = true, desc = "remote flash" })
	end,
}
