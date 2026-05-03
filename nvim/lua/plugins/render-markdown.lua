require("render-markdown").setup({
    mode = "virtual",
    render_modules = {
        ["code_languages"] = { enabled = true },
        ["dash"] = { enabled = true },
        ["lists"] = {
            enabled = true,
            bullet = "•",
            indent = true,
            item = "•",
            check = {
                enabled = true,
                icon = " ",
            },
        },
        ["tables"] = { enabled = true },
        ["callouts"] = { enabled = true },
        [" 数学"] = {
            enabled = true,
            engine = "katex",
        },
    },
    code_blocks = {
        width = 0,
        left_pad = 0,
        right_pad = 0,
        border = "none",
        highlight = "Normal",
        title = "Title",
        language = "Language",
    },
    dash = {
        sublist_indent = 2,
        indent = 2,
    },
    bullets = {
        render_modes = false,
        icons = { '●', '○', '◆', '◇' },
        ordered_icons = function(ctx)
            local value = vim.trim(ctx.value)
            local index = tonumber(value:sub(1, #value - 1))
            return ('%d.'):format(index > 1 and index or ctx.index)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
        scope_highlight = {},
    },
    quote = { icon = '▋' },
    anti_conceal = {
        enabled = true,
        ignore = {
            code_background = true,
            sign = true,
        },
        above = 0,
        below = 0,
    },
})