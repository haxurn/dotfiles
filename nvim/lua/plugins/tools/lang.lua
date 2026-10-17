-- small per-filetype extras
return {
	{ "ron-rs/ron.vim", ft = "ron" }, -- ron syntax highlighting
	{
		-- csv column alignment (keys in lua/config/mappings.lua)
		"emmanueltouzery/decisive.nvim",
		ft = { "csv", "tsv" },
	},
}
