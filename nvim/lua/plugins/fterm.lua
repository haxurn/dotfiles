require('FTerm').setup({
    border     = 'rounded',
    blend      = 0,
    dimensions = {
        height = 0.8,
        width  = 0.8,
    },
})

_G.htop = require('FTerm'):new():resize(0.9):toggle()

vim.keymap.set('n', '<leader>z', function()
    require('FTerm').open()
end)

vim.keymap.set('t', '<Esc>', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>')