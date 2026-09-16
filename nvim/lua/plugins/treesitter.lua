-- nvim-treesitter (main branch) under vim-plug: install parsers, start highlight + indent per buffer.
local langs = {
	"bash", "c", "cpp", "css", "diff", "dockerfile", "git_config", "git_rebase", "gitcommit",
	"gitignore", "go", "html", "java", "javascript", "json", "lua", "markdown",
	"markdown_inline", "python", "query", "regex", "rust", "sql", "toml", "tsx", "typescript",
	"vim", "vimdoc", "yaml",
}

local ok, ts = pcall(require, "nvim-treesitter")
if ok and type(ts.install) == "function" then
	pcall(ts.install, langs) -- async; installs missing parsers
end

-- treesitter indent is worse than the builtin for these
local no_ts_indent = { markdown = true, yaml = true, python = true }

local function attach(buf)
	if not pcall(vim.treesitter.start, buf) then return end
	local ft = vim.bo[buf].filetype
	if not no_ts_indent[ft] then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
	callback = function(ev) attach(ev.buf) end,
})

-- buffers loaded before this ran
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	if vim.api.nvim_buf_is_loaded(buf) then attach(buf) end
end
