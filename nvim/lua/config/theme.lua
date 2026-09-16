-- theme choice is saved in a file for persistence on restart
-- lualine theme gets stored separately due to possible naming differences
-- saved in stdpath("data") so switching themes never dirties the dotfiles repo

local theme_file = vim.fn.stdpath("data") .. "/saved_theme"

local themes = { --add more themes here, if installed
	{ "catppuccin-mocha", "catppuccin" },
	{ "gruvbox", "gruvbox" },
	{ "pywal16", "catppuccin" }, -- pywal16 uses catppuccin lualine theme
}

local current_theme_index = 1

local function apply(colorscheme, lualine_theme)
	local ok = pcall(vim.cmd.colorscheme, colorscheme)
	if not ok then
		pcall(vim.cmd.colorscheme, "catppuccin-mocha")
		lualine_theme = "catppuccin"
	end
	local ok_ll, lualine = pcall(require, "lualine")
	if ok_ll then lualine.setup({ options = { theme = lualine_theme } }) end
end

_G.load_theme = function()
	local file = io.open(theme_file, "r")
	if file then
		local colorscheme = file:read("*l")
		local lualine_theme = file:read("*l")
		file:close()
		for i, t in ipairs(themes) do
			if t[1] == colorscheme then current_theme_index = i end
		end
		apply(colorscheme, lualine_theme)
	else
		apply(unpack(themes[1]))
	end
end

_G.switch_theme = function()
	current_theme_index = current_theme_index % #themes + 1
	local colorscheme, lualine = unpack(themes[current_theme_index])
	apply(colorscheme, lualine)
	local file = io.open(theme_file, "w")
	if file then
		file:write(colorscheme .. "\n" .. lualine)
		file:close()
	end
	vim.notify("theme: " .. colorscheme)
end
