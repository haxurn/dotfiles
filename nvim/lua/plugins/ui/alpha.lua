-- animated dashboard on a bare `nvim`
return {
	"goolord/alpha-nvim",
	lazy = false,
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- ── ASCII art header ────────────────────────────────────────────────
		local header = {
			[[██╗  ██╗ █████╗ ██╗  ██╗██╗   ██╗██████╗ ███╗   ██╗]],
			[[██║  ██║██╔══██╗╚██╗██╔╝██║   ██║██╔══██╗████╗  ██║]],
			[[███████║███████║ ╚███╔╝ ██║   ██║██████╔╝██╔██╗ ██║]],
			[[██╔══██║██╔══██║ ██╔██╗ ██║   ██║██╔══██╗██║╚██╗██║]],
			[[██║  ██║██║  ██║██╔╝ ██╗╚██████╔╝██║  ██║██║ ╚████║]],
			[[╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝]],
		}
		dashboard.section.header.val = header

		-- one highlight group per art line so we can recolor them independently
		local NLINES = #header
		local hl_per_line = {}
		for i = 1, NLINES do
			hl_per_line[i] = { { "AlphaHdr" .. i, 0, 200 } }
		end
		dashboard.section.header.opts.hl = hl_per_line

		-- ── color palette + wave animation ─────────────────────────────────
		-- catppuccin-ish neon loop; edit these hex values to taste
		local palette = {
			"#f38ba8", "#fab387", "#f9e2af", "#a6e3a1",
			"#94e2d5", "#89dceb", "#89b4fa", "#cba6f7", "#f5c2e7",
		}

		local function paint(offset)
			for i = 1, NLINES do
				local c = palette[((offset + i - 1) % #palette) + 1]
				vim.api.nvim_set_hl(0, "AlphaHdr" .. i, { fg = c, bold = true })
			end
		end
		paint(0) -- static colors immediately (also the look in headless / no animation)

		local uv = vim.uv or vim.loop
		local timer

		local function stop_anim()
			if timer then
				timer:stop()
				if not timer:is_closing() then timer:close() end
				timer = nil
			end
		end

		local function start_anim()
			if #vim.api.nvim_list_uis() == 0 then return end -- skip headless
			stop_anim()
			local offset = 0
			timer = uv.new_timer()
			timer:start(0, 110, vim.schedule_wrap(function()
				if vim.bo.filetype ~= "alpha" then stop_anim(); return end
				offset = offset + 1
				paint(offset)
				vim.cmd("redraw")
			end))
		end

		vim.api.nvim_create_autocmd("FileType", { pattern = "alpha", callback = start_anim })
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*",
			callback = function()
				if vim.bo.filetype == "alpha" then stop_anim() end
			end,
		})

		-- ── buttons ────────────────────────────────────────────────────────
		local i = require("config.icons").ui
		local function btn(key, icon, label, cmd)
			return dashboard.button(key, icon .. "  " .. label, cmd)
		end
		dashboard.section.buttons.val = {
			btn("e", i.file_new, "New file", "<cmd>ene <BAR> startinsert<CR>"),
			btn("f", i.search, "Find file", "<cmd>lua require('fzf-lua').files()<CR>"),
			btn("g", i.grep, "Live grep", "<cmd>lua require('fzf-lua').live_grep()<CR>"),
			btn("r", i.history, "Recent files", "<cmd>lua require('fzf-lua').oldfiles()<CR>"),
			btn("s", i.session, "Restore session", "<cmd>lua require('persistence').load()<CR>"),
			btn("t", i.tree, "Browse cwd", "<cmd>NvimTreeOpen<CR>"),
			btn("d", i.folder, "Browse ~/dev", "<cmd>e ~/dev/<CR>"),
			btn("n", i.git, "Neogit", "<cmd>Neogit<CR>"),
			btn("l", i.merge, "Lazygit", "<cmd>lua _G.lazygit:toggle()<CR>"),
			btn("c", i.gear, "Config", "<cmd>e ~/.config/nvim/<CR>"),
			btn("p", i.plugin, "Plugins", "<cmd>Lazy<CR>"),
			btn("m", i.lsp, "Mason", "<cmd>Mason<CR>"),
			btn("?", i.keyboard, "Cheatsheet", "<cmd>Cheatsheet<CR>"),
			btn("q", i.quit, "Quit", "<cmd>qa<CR>"),
		}
		dashboard.section.buttons.opts.hl = "Keyword"

		-- ── footer ─────────────────────────────────────────────────────────
		dashboard.section.footer.val = function()
			local stats = require("lazy").stats()
			return {
				("%s %d/%d plugins in %.1f ms"):format(i.bolt, stats.loaded, stats.count, stats.startuptime),
				"",
				"tip: " .. require("config.cheatsheet").random_tip(),
			}
		end
		dashboard.section.footer.opts.hl = "Comment"

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)

		-- lazy.nvim fills its startup stats after VimEnter; redraw the footer then
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			once = true,
			callback = function() pcall(vim.cmd.AlphaRedraw) end,
		})
	end,
}
