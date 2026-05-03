-- theme choice is saved outside the dotfiles repo for persistence on restart

local theme_file = vim.fn.stdpath("state") .. "/saved_theme"
local legacy_theme_file = vim.fn.stdpath("config") .. "/lua/config/saved_theme"
local themes = {
	{ "catppuccin", "catppuccin" },
	{ "gruvbox", "gruvbox" },
	{ "pywal16", "catppuccin" },
}
local current_theme_index = 1

local function apply_theme(colorscheme, lualine_theme)
	local ok = pcall(vim.cmd, "colorscheme " .. colorscheme)
	if not ok then
		return false
	end

	local has_lualine, lualine = pcall(require, "lualine")
	if has_lualine then
		lualine.setup({ options = { theme = lualine_theme } })
	end

	return true
end

local function read_saved_theme()
	local file = io.open(theme_file, "r") or io.open(legacy_theme_file, "r")
	if not file then
		return themes[1][1], themes[1][2]
	end

	local colorscheme = file:read("*l")
	local lualine_theme = file:read("*l")
	file:close()

	return colorscheme or themes[1][1], lualine_theme or themes[1][2]
end

_G.load_theme = function()
	local colorscheme, lualine_theme = read_saved_theme()
	for i, theme in ipairs(themes) do
		if theme[1] == colorscheme then
			current_theme_index = i
			break
		end
	end

	apply_theme(colorscheme, lualine_theme)
end

_G.switch_theme = function()
	current_theme_index = current_theme_index % #themes + 1
	local colorscheme, lualine = unpack(themes[current_theme_index])
	if not apply_theme(colorscheme, lualine) then
		vim.notify("Theme is not available: " .. colorscheme, vim.log.levels.WARN)
		return
	end

	vim.fn.mkdir(vim.fn.fnamemodify(theme_file, ":h"), "p")
	local file = io.open(theme_file, "w")
	if file then file:write(colorscheme .. "\n" .. lualine) file:close() end
end
