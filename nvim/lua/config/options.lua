local options = {
	laststatus = 3,
	ruler = false,
	showmode = false,
	showcmd = false,
	wrap = true,
	mouse = "a",
	clipboard = "unnamedplus",
	history = 100,
	swapfile = false,
	backup = false,
	undofile = true,
	cursorline = true,
	ttyfast = true,
	smoothscroll = true,
	title = true,

	number = true,
	relativenumber = true,
	numberwidth = 4,

	smarttab = true,
	cindent = true,
	autoindent = false,
	tabstop = 4,

	foldmethod = "expr",
	foldlevel = 99,
	foldexpr = "nvim_treesitter#foldexpr()",

	termguicolors = true,

	ignorecase = true,
	smartcase = true,

	conceallevel = 2,
	concealcursor = "nc",

	splitkeep = 'screen',
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.diagnostic.config({
	signs = false,
})