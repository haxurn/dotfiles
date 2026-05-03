local languages = {
  "bash",
  "c",
  "cpp",
  "css",
  "go",
  "html",
  "java",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "tsx",
  "typescript",
}

local treesitter = require("nvim-treesitter")
treesitter.setup()

vim.api.nvim_create_user_command("TSInstallConfigured", function()
  treesitter.install(languages, { summary = true })
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = languages,
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
