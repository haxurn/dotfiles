require("colorizer").setup({
    user_default_options = {
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
    },
    filetypes = {
        "*",
        "!markdown",
    },
})