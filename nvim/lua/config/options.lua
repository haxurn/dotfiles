local options = {
	laststatus = 3,
	ruler = false, --disable extra numbering
	showmode = false, --not needed due to lualine
	showcmd = false,
	wrap = true, --toggle bound to leader W
	linebreak = true, --wrap at word boundaries
	mouse = "a", --enable mouse
	clipboard = "unnamedplus", --system clipboard (pbcopy / wl-copy / xclip auto-detected)
	history = 100, --command line history
	swapfile = false, --swap just gets in the way, usually
	backup = false,
	undofile = true, --undos are saved to file
	cursorline = true, --highlight line
	ttyfast = true, --faster scrolling
	smoothscroll = true,
	title = true, --automatic window titlebar
	confirm = true, --ask instead of failing on :q with unsaved changes

	number = true, --numbering lines
	relativenumber = true, --toggle bound to leader nn
	numberwidth = 4,
	signcolumn = "yes", --no layout shift when diagnostics appear
	scrolloff = 8,
	sidescrolloff = 8,

	smarttab = true, --indentation stuff
	cindent = true,
	autoindent = false,
	tabstop = 4, --visual width of tab
	shiftwidth = 4,

	foldmethod = "expr",
	foldlevel = 99, --disable folding, lower #s enable
	foldexpr = "v:lua.vim.treesitter.foldexpr()", --nvim-treesitter main has no vimscript foldexpr
	foldtext = "",

	termguicolors = true,

	ignorecase = true, --ignore case while searching
	smartcase = true, --but do not ignore if caps are used
	inccommand = "split", --live preview for :s

	splitright = true,
	splitbelow = true,
	splitkeep = "screen", --stabilize window open/close

	updatetime = 250, --faster CursorHold / gitsigns
	timeoutlen = 400, --which-key popup delay

	conceallevel = 2, --markdown conceal
	concealcursor = "nc",

	spelllang = "en_us",
	spelloptions = "camel",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- diagnostics are configured in lua/plugins/lsp.lua (signs + inline error-lens)
