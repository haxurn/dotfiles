-- mappings, including plugins
-- terminal / lazygit / btop maps live in lua/plugins/fterm.lua
-- LSP maps are buffer-local in lua/plugins/lsp.lua; format in lua/plugins/conform.lua

local function map(m, k, v, desc)
	vim.keymap.set(m, k, v, { noremap = true, silent = true, desc = desc })
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>q", ":BufferClose<CR>")
map("n", "<leader>Q", ":BufferClose!<CR>")
map("n", "<leader>U", "::bufdo bd<CR>") --close all
map("n", "<leader>vs", ":vsplit<CR>:bnext<CR>") --ver split + open next buffer

-- buffer position nav + reorder
map("n", "<AS-h>", "<Cmd>BufferMovePrevious<CR>")
map("n", "<AS-l>", "<Cmd>BufferMoveNext<CR>")
for i = 1, 9 do
	map("n", "<A-" .. i .. ">", "<Cmd>BufferGoto " .. i .. "<CR>")
end
map("n", "<A-0>", "<Cmd>BufferLast<CR>")
map("n", "<A-p>", "<Cmd>BufferPin<CR>")

-- windows - ctrl nav, fn resize
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<F5>", ":resize +2<CR>")
map("n", "<F6>", ":resize -2<CR>")
map("n", "<F7>", ":vertical resize +2<CR>")
map("n", "<F8>", ":vertical resize -2<CR>")

-- fzf and grep
local function fzf(fn, opts)
	return function() require("fzf-lua")[fn](opts) end
end
map("n", "<leader>f", fzf("files"), "find files")
map("n", "<leader>b", fzf("buffers"), "buffers")
map("n", "<leader>o", fzf("oldfiles", { cwd_only = true }), "recent files (cwd)")
map("n", "<leader>g", fzf("live_grep"), "grep")
map("n", "<leader>G", fzf("grep_cword"), "grep word under cursor")
map("n", "<leader>Fh", fzf("files", { cwd = "~/" }), "files: home")
map("n", "<leader>Fc", fzf("files", { cwd = "~/.config" }), "files: .config")
map("n", "<leader>Ff", fzf("files", { cwd = ".." }), "files: parent dir")
map("n", "<leader>Fr", fzf("resume"), "resume last")
map("n", "<leader>Fg", fzf("git_status"), "git status")
map("n", "<leader>Fs", fzf("lsp_document_symbols"), "document symbols")
map("n", "<leader>Fk", fzf("keymaps"), "keymaps")
map("n", "<leader>Fd", fzf("diagnostics_document"), "diagnostics")

-- misc
map("n", "<leader>s", ":%s//g<Left><Left>") --replace all
map("n", "<leader>t", ":NvimTreeToggle<CR>") --open file explorer
map("n", "<leader>p", function() _G.switch_theme() end) --cycle themes
map("n", "<leader>P", ":PlugInstall<CR>") --vim-plug
map("n", "<leader>u", ":UndotreeToggle<CR>") --undo history
map("n", "<leader>w", ":w<CR>") --write but one less key
map("n", "<leader>d", ":w ") --duplicate to new name
map("n", "<leader>x", "<cmd>!chmod +x %<CR>") --make a file executable
map("n", "<leader>mv", ":!mv % ") --move a file to a new dir
map("n", "<leader>R", ":so %<CR>") --reload neovim config
map("v", "<leader>i", "=gv") --auto indent
map("n", "<leader>W", ":set wrap!<CR>") --toggle wrap
map("n", "<leader>l", ":Twilight<CR>") --surrounding dim
-- `gx` (builtin, vim.ui.open) opens the URL/path under cursor on both macOS and Linux

-- quality of life
map("n", "<A-j>", ":m .+1<CR>==") --move line down
map("n", "<A-k>", ":m .-2<CR>==") --move line up
map("v", "<A-j>", ":m '>+1<CR>gv=gv") --move selection down
map("v", "<A-k>", ":m '<-2<CR>gv=gv") --move selection up
map("n", "n", "nzzzv") --next match, centered
map("n", "N", "Nzzzv") --prev match, centered
map("n", "<C-d>", "<C-d>zz") --half-page down, centered
map("n", "<C-u>", "<C-u>zz") --half-page up, centered
map("v", "<", "<gv") --indent left, keep selection
map("v", ">", ">gv") --indent right, keep selection
map("n", "<Esc>", ":noh<CR>") --clear search highlight
map("t", "<C-\\><C-\\>", "<C-\\><C-n>") --terminal: back to normal mode (Esc stays free for TUIs)

-- decisive csv
map("n", "<leader>csa", ":lua require('decisive').align_csv({})<cr>")
map("n", "<leader>csA", ":lua require('decisive').align_csv_clear({})<cr>")
map("n", "[,", ":lua require('decisive').align_csv_prev_col()<cr>")
map("n", "],", ":lua require('decisive').align_csv_next_col()<cr>")

map("n", "<leader>nn", function() --toggle relative vs absolute line numbers
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end)

-- undotree
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_WindowLayout = 2
