-- add / change / delete surrounding pairs
return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	config = function()
		-- nvim-surround: add / change / delete the pair around text
		--   ysiw"  -> surround word with "quotes"
		--   cs"'   -> change "double" to 'single'
		--   ds(    -> delete the surrounding parens
		--   visual + S -> surround the selection
		require("nvim-surround").setup({})
	end,
}
