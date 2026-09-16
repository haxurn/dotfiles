-- autocommands
local aug = vim.api.nvim_create_augroup("dotfiles", { clear = true })
local function au(event, opts)
	opts.group = aug
	vim.api.nvim_create_autocmd(event, opts)
end

-- close nvim-tree if it's the last buffer open
au("BufEnter", {
	callback = function()
		if #vim.api.nvim_list_bufs() == 1 and vim.bo.filetype == "NvimTree" then
			vim.cmd("quit")
		end
	end,
})

-- auto-create missing dirs when saving a file
au("BufWritePre", {
	callback = function(ev)
		if ev.match:match("^%w%w+:[\\/][\\/]") then return end -- skip remote / protocol buffers
		local dir = vim.fn.fnamemodify(ev.match, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
	end,
})

-- lint on write (linters defined in plugins/nvim-lint.lua)
au("BufWritePost", {
	callback = function()
		local ok, lint = pcall(require, "lint")
		if ok then lint.try_lint() end
	end,
})

-- spellcheck + wrap in prose filetypes
au("FileType", {
	pattern = { "markdown", "gitcommit", "text" },
	command = "setlocal spell wrap",
})

-- disable automatic comment continuation on newline
au("FileType", {
	callback = function() vim.opt_local.formatoptions:remove({ "c", "r", "o" }) end,
})

-- highlight text on yank
au("TextYankPost", {
	callback = function() vim.hl.on_yank({ timeout = 300 }) end,
})

-- reload files changed outside nvim (e.g. after lazygit / git checkout)
au({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
	end,
})

-- restore cursor position on file open
au("BufReadPost", {
	callback = function()
		local line = vim.fn.line("'\"")
		if line > 1 and line <= vim.fn.line("$") then vim.cmd("normal! g'\"") end
	end,
})

-- startup time for the dashboard footer
au("VimEnter", {
	callback = function()
		local startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
		vim.g.startup_time_ms = string.format("%.2f ms", startuptime * 1000)
	end,
})

-- relative numbers only in the active window / normal mode
au({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then vim.opt.relativenumber = true end
	end,
})
au({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			-- workaround for https://github.com/neovim/neovim/issues/32068
			if not vim.list_contains({ "@", "-" }, vim.v.event.cmdtype) then vim.cmd("redraw") end
		end
	end,
})
