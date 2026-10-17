-- In-editor cheatsheet with three tabs:
--   1 Keys       every key, what it does, when to use it      (keys.lua)
--   2 Scenarios  step-by-step recipes for real tasks          (scenarios.lua)
--   3 Grammar    how vim commands combine                     (grammar.lua)
-- Open: <leader>k (keys), <leader>K (scenarios), :Cheatsheet [keys|scenarios|grammar]
-- Inside: 1 2 3 switch tab, <Tab>/<S-Tab> next/prev section, / search,
--         s fuzzy-find anything, t new tip, q / <Esc> close.
-- :Tip shows one random tip (tips.lua).
local M = {}

local TABS = {
	{ id = "keys", label = "Keys" },
	{ id = "scenarios", label = "Scenarios" },
	{ id = "grammar", label = "Vim grammar" },
}

local ns = vim.api.nvim_create_namespace("cheatsheet")

-- show the leader as the key you actually press
local function pretty(str) return (str:gsub("<leader>", "Space ")) end

local function data(id) return require("config.cheatsheet." .. id) end

function M.random_tip()
	local tips = data("tips")
	math.randomseed(vim.uv.hrtime())
	return pretty(tips[math.random(#tips)])
end

function M.tip()
	vim.notify(M.random_tip(), vim.log.levels.INFO, { title = "nvim tip" })
end

local function set_hl()
	local hl = vim.api.nvim_set_hl
	hl(0, "CheatTitle", { link = "Title", default = true })
	hl(0, "CheatTabActive", { link = "CurSearch", default = true })
	hl(0, "CheatTab", { link = "Comment", default = true })
	hl(0, "CheatSection", { link = "Function", default = true })
	hl(0, "CheatKey", { link = "Special", default = true })
	hl(0, "CheatDesc", { link = "Normal", default = true })
	hl(0, "CheatHint", { link = "Comment", default = true })
	hl(0, "CheatGoal", { link = "String", default = true })
	hl(0, "CheatTip", { link = "DiagnosticHint", default = true })
	hl(0, "CheatNum", { link = "Number", default = true })
end

local function wrap(text, width)
	local out, line = {}, ""
	for word in text:gmatch("%S+") do
		if line ~= "" and vim.fn.strdisplaywidth(line .. " " .. word) > width then
			table.insert(out, line)
			line = word
		else
			line = line == "" and word or (line .. " " .. word)
		end
	end
	if line ~= "" then table.insert(out, line) end
	return out
end

-- Builder collects lines, highlight ranges (byte columns) and section rows.
local function builder(width)
	local b = { lines = {}, hls = {}, starts = {}, width = width }
	function b.add(text, group)
		table.insert(b.lines, text)
		if group then table.insert(b.hls, { #b.lines - 1, 0, #text, group }) end
		return #b.lines
	end
	function b.hl(row, from, to, group) table.insert(b.hls, { row - 1, from, to, group }) end
	function b.section(title, icon)
		b.add("")
		table.insert(b.starts, #b.lines + 1)
		local icons = require("config.icons").ui
		b.add("  " .. (icons[icon] or icons.dots) .. "  " .. title, "CheatSection")
		b.add("  " .. string.rep("─", width - 4), "CheatHint")
	end
	-- "    key<pad>desc" plus optional dimmed detail lines under the description
	function b.row(key, desc, detail, keyw, indent)
		indent = indent or "    "
		key = pretty(key)
		local pad = string.rep(" ", math.max(1, keyw - vim.fn.strdisplaywidth(key)))
		local descw = width - #indent - keyw - 2
		local desc_lines = wrap(pretty(desc), descw)
		local row = b.add(indent .. key .. pad .. (desc_lines[1] or ""))
		b.hl(row, #indent, #indent + #key, "CheatKey")
		local blank = indent .. string.rep(" ", keyw)
		for i = 2, #desc_lines do b.add(blank .. desc_lines[i]) end
		if detail then
			for _, l in ipairs(wrap(pretty(detail), descw - 2)) do b.add(blank .. "  " .. l, "CheatHint") end
		end
		return row
	end
	return b
end

local function key_width(items, field)
	local w = 0
	for _, it in ipairs(items) do w = math.max(w, vim.fn.strdisplaywidth(pretty(it[field or 1]))) end
	return w + 2
end

local render = {}

function render.keys(b)
	local all = {}
	for _, s in ipairs(data("keys")) do vim.list_extend(all, s[3]) end
	local keyw = math.min(22, key_width(all))
	for _, s in ipairs(data("keys")) do
		b.section(s[1], s[2])
		for _, it in ipairs(s[3]) do b.row(it[1], it[2], it[3], keyw) end
	end
end

function render.scenarios(b)
	for n, sc in ipairs(data("scenarios")) do
		b.section(n .. ". " .. sc[1], sc[2])
		for _, l in ipairs(wrap(sc[3], b.width - 6)) do b.add("    " .. l, "CheatGoal") end
		b.add("")
		local keyw = key_width(sc[4]) + 4
		for i, step in ipairs(sc[4]) do
			local num = ("%d. "):format(i)
			local row = b.row(num .. step[1], step[2], nil, keyw)
			b.hl(row, 4, 4 + #num, "CheatNum")
		end
		if sc[5] then
			b.add("")
			for i, l in ipairs(wrap("tip: " .. pretty(sc[5]), b.width - 6)) do
				b.add("    " .. (i > 1 and "     " or "") .. l, "CheatTip")
			end
		end
	end
end

function render.grammar(b)
	for _, g in ipairs(data("grammar")) do
		b.section(g[1], g[2])
		if g[3] then
			for _, l in ipairs(wrap(g[3], b.width - 6)) do b.add("    " .. l, "CheatGoal") end
			b.add("")
		end
		local keyw = math.min(26, key_width(g[4]))
		for _, r in ipairs(g[4]) do b.row(r[1], r[2], nil, keyw) end
	end
end

local function build(tab, width)
	local b = builder(width)
	local icons = require("config.icons").ui
	b.add("  " .. icons.keyboard .. "  nvim cheatsheet", "CheatTitle")
	-- tab bar
	local bar, row = "  ", nil
	local spans = {}
	for i, t in ipairs(TABS) do
		local label = (" %d %s "):format(i, t.label)
		table.insert(spans, { #bar, #bar + #label, t.id == tab })
		bar = bar .. label .. "  "
	end
	row = b.add(bar)
	for _, sp in ipairs(spans) do b.hl(row, sp[1], sp[2], sp[3] and "CheatTabActive" or "CheatTab") end
	b.add("  1 2 3 tabs · Tab/S-Tab section · / search · s find anything · t tip · q close", "CheatHint")
	b.add("")
	for _, l in ipairs(wrap(icons.bolt .. " " .. M.random_tip(), width - 4)) do b.add("  " .. l, "CheatTip") end
	render[tab](b)
	b.add("")
	return b
end

local state = {}

local function paint(tab, cursor_row)
	local width = vim.api.nvim_win_get_width(state.win)
	local b = build(tab, width)
	state.tab, state.starts = tab, b.starts
	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, b.lines)
	vim.bo[state.buf].modifiable = false
	vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
	for _, h in ipairs(b.hls) do
		pcall(vim.api.nvim_buf_set_extmark, state.buf, ns, h[1], h[2], { end_col = h[3], hl_group = h[4] })
	end
	vim.api.nvim_win_set_config(state.win, { title = " cheatsheet · " .. tab .. " ", title_pos = "center" })
	vim.api.nvim_win_set_cursor(state.win, { math.min(cursor_row or 1, #b.lines), 0 })
	if cursor_row then vim.cmd("normal! zt") end
end

local function jump(dir)
	local row = vim.api.nvim_win_get_cursor(state.win)[1]
	local starts, target = state.starts, nil
	if dir > 0 then
		for _, s in ipairs(starts) do if s > row then target = s break end end
		target = target or starts[1]
	else
		for i = #starts, 1, -1 do if starts[i] < row then target = starts[i] break end end
		target = target or starts[#starts]
	end
	vim.api.nvim_win_set_cursor(state.win, { target, 0 })
	vim.cmd("normal! zt")
end

local function close()
	if state.win and vim.api.nvim_win_is_valid(state.win) then vim.api.nvim_win_close(state.win, true) end
end

-- fuzzy search across all three tabs; picking a line opens the sheet there
local function find_anything()
	local entries, targets = {}, {}
	local function add(text, tab, needle)
		table.insert(entries, text)
		targets[text] = { tab, needle }
	end
	for _, s in ipairs(data("keys")) do
		for _, it in ipairs(s[3]) do
			add(("%-20s %-58s [keys: %s]"):format(pretty(it[1]), pretty(it[2]), s[1]), "keys", pretty(it[1]))
		end
	end
	for n, sc in ipairs(data("scenarios")) do
		add(("%-20s %-58s [scenario]"):format("recipe " .. n, sc[1]), "scenarios", n .. ". " .. sc[1])
	end
	for _, g in ipairs(data("grammar")) do
		for _, r in ipairs(g[4]) do
			add(("%-20s %-58s [grammar]"):format(r[1], r[2]), "grammar", r[1])
		end
	end
	require("fzf-lua").fzf_exec(entries, {
		prompt = "cheatsheet> ",
		winopts = { title = " find in cheatsheet ", height = 0.6, width = 0.8 },
		actions = {
			["default"] = function(sel)
				local t = sel[1] and targets[sel[1]]
				if not t then return end
				M.open(t[1])
				for i, l in ipairs(vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)) do
					if l:find(t[2], 1, true) then
						vim.api.nvim_win_set_cursor(state.win, { i, 0 })
						vim.cmd("normal! zz")
						break
					end
				end
			end,
		},
	})
end

function M.open(tab)
	tab = tab or "keys"
	if not render[tab] then tab = "keys" end
	set_hl()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_set_current_win(state.win)
		return paint(tab)
	end
	local width = math.min(100, math.floor(vim.o.columns * 0.9))
	local height = math.floor(vim.o.lines * 0.85)
	state.buf = vim.api.nvim_create_buf(false, true)
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].filetype = "cheatsheet"
	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2) - 1,
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.wo[state.win].cursorline = true
	vim.wo[state.win].wrap = false
	vim.wo[state.win].scrolloff = 1 -- so Tab puts the section header at the top

	local function map(lhs, fn) vim.keymap.set("n", lhs, fn, { buffer = state.buf, nowait = true, silent = true }) end
	map("q", close)
	map("<Esc>", close)
	map("<Tab>", function() jump(1) end)
	map("<S-Tab>", function() jump(-1) end)
	map("s", function() close() find_anything() end)
	map("t", M.tip)
	for i, t in ipairs(TABS) do map(tostring(i), function() paint(t.id) end) end

	paint(tab)
end

vim.api.nvim_create_user_command("Cheatsheet", function(o) M.open(o.args ~= "" and o.args or nil) end, {
	nargs = "?",
	complete = function() return vim.tbl_map(function(t) return t.id end, TABS) end,
	desc = "keymap cheatsheet",
})
vim.api.nvim_create_user_command("Tip", M.tip, { desc = "random nvim tip" })
vim.keymap.set("n", "<leader>k", function() M.open("keys") end, { desc = "cheatsheet: keys" })
vim.keymap.set("n", "<leader>K", function() M.open("scenarios") end, { desc = "cheatsheet: scenarios" })

return M
