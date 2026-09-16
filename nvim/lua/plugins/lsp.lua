-- LSP: mason installs servers, mason-lspconfig auto-enables them (nvim 0.11+ native)
require("mason").setup({
	ui = {
		border = "rounded",
		icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
	},
})

-- servers auto-installed + enabled
local servers = {
	"lua_ls", "pyright", "bashls",
	"rust_analyzer", "gopls", "clangd",
	"ts_ls", "html", "cssls", "eslint",
	"jsonls", "yamlls", "dockerls", "ruff",
	"jdtls",
}

-- completion capabilities advertised to every server (from blink)
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
	vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
end

-- per-server tweaks (must be set before enable)
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } }, -- silence 'undefined global vim'
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = true,
})

-- formatters / linters used by conform + nvim-lint, installed through mason without extra plugins
local tools = { "stylua", "shfmt", "prettierd", "clang-format", "shellcheck", "hadolint" }
local ok_reg, reg = pcall(require, "mason-registry")
if ok_reg then
	reg.refresh(function()
		for _, name in ipairs(tools) do
			local ok_pkg, pkg = pcall(reg.get_package, name)
			if ok_pkg and not pkg:is_installed() then pkg:install() end
		end
	end)
end

-- diagnostics look: signs + underline, NO virtual_text (tiny-inline-diagnostic draws it)
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN]  = " ",
			[vim.diagnostic.severity.INFO]  = " ",
			[vim.diagnostic.severity.HINT]  = "󰌶 ",
		},
	},
	float = { border = "rounded", source = true },
})

-- buffer-local keymaps when a language server attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local b = ev.buf
		local fzf = require("fzf-lua")
		local function m(k, fn, desc)
			vim.keymap.set("n", k, fn, { buffer = b, silent = true, desc = desc })
		end
		m("gd", fzf.lsp_definitions, "definition")
		m("gD", vim.lsp.buf.declaration, "declaration")
		m("gr", fzf.lsp_references, "references")
		m("gi", fzf.lsp_implementations, "implementation")
		m("gy", fzf.lsp_typedefs, "type definition")
		m("K", vim.lsp.buf.hover, "hover docs")
		m("<leader>rn", vim.lsp.buf.rename, "rename symbol")
		m("<leader>ca", vim.lsp.buf.code_action, "code action")
		m("<leader>ci", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = b }), { bufnr = b })
		end, "toggle inlay hints")
		m("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "prev diagnostic")
		m("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "next diagnostic")
		m("<leader>e", vim.diagnostic.open_float, "line diagnostics")
	end,
})
