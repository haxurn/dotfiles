-- nvim-treesitter-textobjects (main): select / move by syntax nodes
local ok, tso = pcall(require, "nvim-treesitter-textobjects")
if not ok then return end

tso.setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select").select_textobject
local move = require("nvim-treesitter-textobjects.move")

local objects = {
	af = "@function.outer", ["if"] = "@function.inner",
	ac = "@class.outer",    ic = "@class.inner",
	aa = "@parameter.outer", ia = "@parameter.inner",
}
for key, query in pairs(objects) do
	vim.keymap.set({ "x", "o" }, key, function() select(query, "textobjects") end, { desc = query })
end

vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "next function" })
vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "prev function" })
vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "next class" })
vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "prev class" })
