-- catgoose/nvim-colorizer.lua (maintained fork of norcalli's).
-- `css`/`css_fn` are deliberately not used: they switch `names` back on, and
-- highlighting every word like "Blue" was not wanted here.
return {
	"catgoose/nvim-colorizer.lua",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
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
	},
}
