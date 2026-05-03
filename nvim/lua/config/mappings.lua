-- mappings, including plugins

local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
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
map("n", "<leader>U", "::bufdo bd<CR>")
map('n', '<leader>vs', ':vsplit<CR>:bnext<CR>')

-- buffer position nav + reorder
map('n', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<A-0>', '<Cmd>BufferLast<CR>')
map('n', '<A-p>', '<Cmd>BufferPin<CR>')

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
map("n", "<leader>f", ":lua require('fzf-lua').files()<CR>")
map("n", "<leader>Fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>")
map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>")
map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>")
map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>")
map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>")
map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>")
map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>")

-- misc
map("n", "<leader>s", ":%s//g<Left><Left>")
map("n", "<leader>t", ":NvimTreeToggle<CR>")
map("n", "<leader>p", switch_theme)
map("n", "<leader>P", ":PlugInstall<CR>")
map('n', '<leader>z', ":lua require('FTerm').open()<CR>")
map('t', '<Esc>', '<C-\\><C-n><CMD>lua require(\"FTerm\").close()<CR>')
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>d", ":w ")
map("n", "<leader>x", "<cmd>!chmod +x %<CR>")
map("n", "<leader>mv", ":!mv % ")
map("n", "<leader>R", ":so %<CR>")
map("n", "<leader>u", ':silent !xdg-open "<cWORD>" &<CR>')
map("v", "<leader>i", "=gv")
map("n", "<leader>W", ":set wrap!<CR>")
map("n", "<leader>l", ":Twilight<CR>")

-- decisive csv
map("n", "<leader>csa", ":lua require('decisive').align_csv({})<cr>")
map("n", "<leader>csA", ":lua require('decisive').align_csv_clear({})<cr>")
map("n", "[c", ":lua require('decisive').align_csv_prev_col()<cr>")
map("n", "]c", ":lua require('decisive').align_csv_next_col()<cr>")

map("n", "<leader>H", function()
    _G.htop:toggle()
end)

map("n", "<leader>ma", function()
	local bufdir = vim.fn.expand("%:p:h")
	vim.cmd("lcd " .. bufdir)
	vim.cmd("!sudo make uninstall && sudo make clean install %")
end)

map("n", "<leader>nn", function()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end)