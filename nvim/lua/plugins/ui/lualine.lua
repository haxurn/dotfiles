-- statusline. theme = "auto" follows whatever colorscheme is active.
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		-- blank statusline until lualine draws, so startup doesn't flash the default one
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then vim.o.statusline = " " else vim.o.laststatus = 0 end
	end,
	opts = function()
		local icons = require("config.icons")
		vim.o.laststatus = vim.g.lualine_laststatus

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn", "info", "hint" },
			symbols = {
				error = icons.diagnostics.Error,
				warn = icons.diagnostics.Warn,
				info = icons.diagnostics.Info,
				hint = icons.diagnostics.Hint,
			},
			colored = true,
			update_in_insert = false,
			cond = function() return vim.bo.filetype ~= "markdown" end,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed },
			source = function() -- reuse gitsigns' counts instead of running git again
				local gs = vim.b.gitsigns_status_dict
				if gs then return { added = gs.added, modified = gs.changed, removed = gs.removed } end
			end,
		}

		local mode = {
			"mode",
			fmt = function(str) return "-- " .. str .. " --" end,
		}

		local branch = { "branch", icon = icons.git.branch }

		-- names of the language servers attached to this buffer
		local lsp = {
			function()
				local names = {}
				for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, c.name)
				end
				return icons.ui.lsp .. " " .. table.concat(names, " ")
			end,
			cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
		}

		-- macro recording indicator (cmdheight stays 0-friendly with noice)
		local recording = {
			function() return "recording @" .. vim.fn.reg_recording() end,
			cond = function() return vim.fn.reg_recording() ~= "" end,
			color = "DiagnosticWarn",
		}

		local harpoon = {
			function()
				local ok, h = pcall(require, "harpoon")
				if not ok then return "" end
				local list = h:list()
				local path = vim.fn.expand("%:p:.")
				for idx, item in ipairs(list.items) do
					if item.value == path then return icons.ui.harpoon .. " " .. idx .. "/" .. list:length() end
				end
				return ""
			end,
			cond = function() return package.loaded["harpoon"] ~= nil end,
		}

		local progress = function()
			local current_line = vim.fn.line(".")
			local total_lines = vim.fn.line("$")
			local chars = icons.line.progress --adding more chars will still work
			local line_ratio = current_line / total_lines
			local index = math.max(1, math.ceil(line_ratio * #chars))
			return chars[index] .. " " .. math.floor(line_ratio * 100) .. "%%"
		end

		return {
			options = {
				icons_enabled = true,
				theme = "auto", --auto allows for theme switching
				component_separators = { left = "", right = "" },
				section_separators = { left = icons.line.sep_left, right = icons.line.sep_right },
				disabled_filetypes = { statusline = { "alpha", "dashboard" } },
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { branch },
				lualine_b = { mode },
				lualine_c = { diagnostics, harpoon, recording },
				lualine_x = { lsp, diff, "fileformat", "filetype" },
				lualine_y = { "location" },
				lualine_z = { progress },
			},
			extensions = { "nvim-tree", "lazy", "mason", "trouble", "fzf", "nvim-dap-ui", "oil", "quickfix" },
		}
	end,
}
