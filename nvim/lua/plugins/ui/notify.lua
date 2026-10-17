-- pretty notification popups; noice routes vim.notify here once it loads
return {
	"rcarriga/nvim-notify",
	lazy = true,
	opts = {
		stages = "fade",
		timeout = 2500,
		render = "wrapped-compact",
		fps = 60,
		top_down = true,
		max_width = 60,
		background_colour = "#000000", -- transparent themes have no Normal bg to blend with
		on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
	},
	init = function()
		-- messages sent before noice is up still get the popup style
		vim.notify = function(...) return require("notify")(...) end
	end,
}
