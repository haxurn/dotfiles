require("lualine").setup({
    options = {
        theme = "catppuccin",
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
        disabled_filetypes = { statusline = {}, winbar = {} },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { 'diagnostics' },
        lualine_x = { 'filename' },
        lualine_y = { 'filetype', 'encoding', 'fileformat' },
        lualine_z = { 'location', 'progress' },
    },
})