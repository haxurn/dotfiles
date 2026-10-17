-- floating cmdline, search and message popups (replaces the bottom message area)
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	opts = {
		lsp = {
			-- markdown rendering for hover / docs
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
			progress = { enabled = false }, -- fidget shows LSP progress
			signature = { enabled = false }, -- blink.cmp shows signatures
		},
		presets = {
			bottom_search = true, -- classic bottom search bar
			command_palette = true, -- cmdline and popupmenu together
			long_message_to_split = true,
			lsp_doc_border = true,
		},
		routes = {
			-- hide "written" / undo / line-count chatter
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
						{ find = "%d fewer lines" },
						{ find = "%d more lines" },
					},
				},
				opts = { skip = true },
			},
			-- mason install chatter goes to the small corner view, not stacked popups
			{ filter = { event = "notify", find = "mason" }, view = "mini" },
		},
	},
	keys = {
		{ "<leader>Nl", function() require("noice").cmd("last") end, desc = "last message" },
		{ "<leader>Nh", function() require("noice").cmd("history") end, desc = "message history" },
		{ "<leader>Nd", function() require("noice").cmd("dismiss") end, desc = "dismiss messages" },
		{ "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "redirect cmdline" },
	},
	config = function(_, opts)
		-- lazy may have printed messages before noice loaded; clear them so they don't stack
		if vim.o.filetype == "lazy" then vim.cmd([[messages clear]]) end
		require("noice").setup(opts)
	end,
}
