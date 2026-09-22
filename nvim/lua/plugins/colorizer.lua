-- catgoose/nvim-colorizer.lua (maintained fork of norcalli's).
-- New API: filetypes + user_default_options, not two positional tables.
-- `css`/`css_fn` are deliberately not used: they switch `names` back on, and
-- highlighting every word like "Blue" was not wanted here.
require("colorizer").setup({
	filetypes = { "*" },
	user_default_options = {
		RGB = true, -- #RGB
		RRGGBB = true, -- #RRGGBB
		RRGGBBAA = true, -- #RRGGBBAA
		names = false, -- do NOT highlight bare words like "Blue"
		rgb_fn = true, -- rgb() / rgba()
		hsl_fn = true, -- hsl() / hsla()
		mode = "background",
	},
})
