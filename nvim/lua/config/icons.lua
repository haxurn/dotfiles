-- one icon set for the whole config (needs a Nerd Font).
-- every plugin reads from here, so swapping a glyph changes it everywhere.
local M = {}

M.diagnostics = {
	Error = " ",
	Warn = " ",
	Info = " ",
	Hint = "󰛩 ",
}

M.git = {
	added = " ",
	modified = " ",
	removed = " ",
	renamed = " ",
	ignored = " ",
	untracked = " ",
	staged = " ",
	conflict = " ",
	branch = "",
}

M.dap = {
	Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" },
	Breakpoint = { " ", "DiagnosticError" },
	BreakpointCondition = { " ", "DiagnosticWarn" },
	BreakpointRejected = { " ", "DiagnosticError" },
	LogPoint = { " ", "DiagnosticInfo" },
}

M.test = {
	passed = " ",
	failed = " ",
	running = " ",
	skipped = " ",
	unknown = " ",
	watching = "󰔟 ",
}

-- completion menu, symbol outlines, breadcrumbs
M.kinds = {
	Array = " ",
	Boolean = " ",
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Copilot = " ",
	Enum = " ",
	EnumMember = " ",
	Event = " ",
	Field = " ",
	File = " ",
	Folder = " ",
	Function = "󰊕 ",
	Interface = " ",
	Key = " ",
	Keyword = " ",
	Method = " ",
	Module = " ",
	Namespace = " ",
	Null = "󰟢 ",
	Number = " ",
	Object = "󰅩 ",
	Operator = " ",
	Package = " ",
	Property = " ",
	Reference = " ",
	Snippet = " ",
	String = " ",
	Struct = " ",
	Text = " ",
	TypeParameter = " ",
	Unit = " ",
	Value = " ",
	Variable = " ",
}

M.ui = {
	folder = "󰉋",
	folder_open = "󰝰",
	folder_empty = "󰉖",
	folder_empty_open = "󰷏",
	folder_symlink = "󱧮",
	file = "",
	file_new = "󰝒",
	arrow_closed = "",
	arrow_open = "",
	modified = "",
	close = "󰅖",
	pin = "󰐃",
	lock = "󰌾",
	gear = "",
	bug = "󰃤",
	terminal = "",
	search = "󰍉",
	grep = "󰺯",
	history = "󰋚",
	keyboard = "󰌌",
	palette = "󰏘",
	plugin = "󰏖",
	quit = "󰈆",
	tree = "󰙅",
	session = "󰦛",
	harpoon = "󰀱",
	clipboard = "󰆒",
	test = "󰂖",
	format = "󰉢",
	code = "󰅴",
	toggle = "󰔡",
	window = "󰖲",
	cursor = "󰳽",
	git = "󰊢",
	diff = "󰕚",
	merge = "󰘭",
	lsp = "󰒓",
	notes = "󰏫",
	list = "󰉹",
	csv = "󰆼",
	bolt = "󱐋",
	fix = "󰁨",
	dots = "󰇘",
	sleep = "󰒲",
	speed = "",
}

-- statusline / tabline drawing characters
M.line = {
	sep_left = "", -- powerline right-pointing triangle
	sep_right = "",
	progress = { "", "", "" }, -- hourglass start/half/end
}

return M
