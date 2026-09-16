-- conform.nvim: formatters. Format on save is OPT-IN (<leader>cF toggles it).
local conform = require("conform")
local prettier = { "prettierd", "prettier", stop_after_first = true }

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		go = { "gofmt" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		python = { "ruff_organize_imports", "ruff_format" },
		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,
		json = prettier,
		jsonc = prettier,
		yaml = prettier,
		markdown = prettier,
		css = prettier,
		html = prettier,
		["_"] = { "trim_whitespace" },
	},
	default_format_opts = { lsp_format = "fallback" },
	format_on_save = function(buf)
		if not vim.g.autoformat or vim.b[buf].autoformat == false then return end
		return { timeout_ms = 1000 }
	end,
})

vim.g.autoformat = false

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	conform.format({ async = true })
end, { desc = "format" })
vim.keymap.set("n", "<leader>cF", function()
	vim.g.autoformat = not vim.g.autoformat
	vim.notify("format on save: " .. tostring(vim.g.autoformat))
end, { desc = "toggle format on save" })
