-- linters only for what LSP does not cover; each guarded on the binary being installed
local lint = require("lint")

local wanted = {
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	zsh = { "shellcheck" },
	dockerfile = { "hadolint" },
}

local by_ft = {}
for ft, linters in pairs(wanted) do
	local available = {}
	for _, l in ipairs(linters) do
		if vim.fn.executable(l) == 1 then table.insert(available, l) end
	end
	if #available > 0 then by_ft[ft] = available end
end
lint.linters_by_ft = by_ft

-- runs on BufWritePost (see config/autocmd.lua)
