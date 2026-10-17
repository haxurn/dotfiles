-- theme choice is saved in a file for persistence on restart
-- saved in stdpath("data") so switching themes never dirties the dotfiles repo
-- lualine uses theme = "auto" and re-reads colors on every :colorscheme
-- colorschemes are lazy: lazy.nvim loads the plugin when :colorscheme asks for it

local theme_file = vim.fn.stdpath("data") .. "/saved_theme"

local themes = { --add more themes here (plugin spec in plugins/ui/colorscheme.lua)
	"catppuccin", -- flavour set in plugins/ui/colorscheme.lua
	"tokyonight",
	"kanagawa",
	"rose-pine",
	"gruvbox",
}
-- pywal16 only makes sense once `wal` has generated colors
if vim.uv.fs_stat(vim.fn.expand("~/.cache/wal/colors")) then table.insert(themes, "pywal16") end

local current_theme_index = 1

local function apply(colorscheme)
	if not pcall(vim.cmd.colorscheme, colorscheme) then
		pcall(vim.cmd.colorscheme, "catppuccin")
	end
end

_G.load_theme = function()
	local file = io.open(theme_file, "r")
	local colorscheme = file and file:read("*l")
	if file then file:close() end
	for i, t in ipairs(themes) do
		if t == colorscheme then current_theme_index = i end
	end
	apply(themes[current_theme_index])
end

_G.switch_theme = function()
	current_theme_index = current_theme_index % #themes + 1
	local colorscheme = themes[current_theme_index]
	apply(colorscheme)
	local file = io.open(theme_file, "w")
	if file then
		file:write(colorscheme .. "\n")
		file:close()
	end
	vim.notify("theme: " .. colorscheme)
end
