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
dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "󰍉  Find file", ":lua require('fzf-lua').files() <CR>"),
	dashboard.button("t", "  Browse cwd", ":NvimTreeOpen<CR>"),
	dashboard.button("r", "  Recent files", ":lua require('fzf-lua').oldfiles() <CR>"),
	dashboard.button("d", "󰲋  Browse ~/dev", ":e ~/dev/<CR>"),
	dashboard.button("g", "  Lazygit", ":lua _G.lazygit:toggle()<CR>"),
	dashboard.button("c", "  Config", ":e ~/.config/nvim/<CR>"),
	dashboard.button("m", "  Mappings", ":e ~/.config/nvim/lua/config/mappings.lua<CR>"),
	dashboard.button("p", "  Plugins", ":PlugInstall<CR>"),
	dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
}
dashboard.section.buttons.opts.hl = "Keyword"

-- ── footer ─────────────────────────────────────────────────────────
dashboard.section.footer.val = function()
	return "⚡ " .. (vim.g.startup_time_ms or "")
end
dashboard.section.footer.opts.hl = "Comment"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
