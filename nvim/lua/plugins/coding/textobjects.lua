-- syntax-aware text objects and motions
--   mini.ai owns selection (vaf, cif, dia, ...); treesitter-textobjects owns ]f [f ]c [c moves
return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
			local move = require("nvim-treesitter-textobjects.move")
			local function m(key, fn, query, desc)
				vim.keymap.set({ "n", "x", "o" }, key, function() move[fn](query, "textobjects") end, { desc = desc })
			end
			m("]f", "goto_next_start", "@function.outer", "next function")
			m("[f", "goto_previous_start", "@function.outer", "prev function")
			m("]c", "goto_next_start", "@class.outer", "next class")
			m("[c", "goto_previous_start", "@class.outer", "prev class")
			m("]a", "goto_next_start", "@parameter.inner", "next argument")
			m("[a", "goto_previous_start", "@parameter.inner", "prev argument")
		end,
	},
	{
		-- a/i text objects: f function, c class, a argument, o block/loop/cond, q quote,
		-- b bracket, t tag, u call, d digits, e word segment (camelCase), g whole buffer
		"nvim-mini/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			local ts = ai.gen_spec.treesitter
			return {
				n_lines = 500,
				custom_textobjects = {
					f = ts({ a = "@function.outer", i = "@function.inner" }),
					c = ts({ a = "@class.outer", i = "@class.inner" }),
					o = ts({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
					d = { "%f[%d]%d+" },
					e = {
						{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
						"^().*()$",
					},
					g = function()
						local from = { line = 1, col = 1 }
						local to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) }
						return { from = from, to = to }
					end,
					u = ai.gen_spec.function_call(),
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
				},
			}
		end,
	},
}
