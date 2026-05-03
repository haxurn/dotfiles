-- theme choice is saved in a file for persistence on restart

local theme_file = vim.fn.stdpath("config") .. "/lua/config/saved_theme"

_G.load_theme = function()
    local file = io.open(theme_file, "r")
	if file then
		local colorscheme = file:read("*l")
		local lualine_theme = file:read("*l")
		vim.cmd("colorscheme " .. colorscheme)
		require("lualine").setup({ options = { theme = lualine_theme } })
	file:close() end
end

local themes = {
	{ "catppuccin-nvim", "catppuccin" },
	{ "gruvbox", "gruvbox" },
	{ "pywal16", "catppuccin" },
}

local current_theme_index = 1

_G.switch_theme = function()
	current_theme_index = current_theme_index % #themes + 1
	local colorscheme, lualine = unpack(themes[current_theme_index])
	vim.cmd("colorscheme " .. colorscheme)
	require("lualine").setup({ options = { theme = lualine } })
	local file = io.open(theme_file, "w")
	if file then file:write(colorscheme .. "\n" .. lualine) file:close() end
end