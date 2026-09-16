-- floating terminals: plain shell, lazygit, btop
local fterm = require("FTerm")

fterm.setup({ border = "rounded", dimensions = { height = 0.85, width = 0.85 } })

_G.lazygit = fterm:new({
	ft = "fterm_lazygit",
	cmd = "lazygit",
	dimensions = { height = 0.95, width = 0.95 },
})
_G.btop = fterm:new({ ft = "fterm_btop", cmd = "btop" })

vim.keymap.set({ "n", "t" }, "<A-z>", function() fterm.toggle() end, { desc = "toggle terminal" })
vim.keymap.set("n", "<leader>z", function() fterm.open() end, { desc = "floating terminal" })
vim.keymap.set("n", "<leader>hg", function() _G.lazygit:toggle() end, { desc = "lazygit" })
vim.keymap.set("n", "<leader>H", function() _G.btop:toggle() end, { desc = "btop" })
