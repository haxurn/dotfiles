-- neotest: run / debug tests from the editor, results inline and in a summary tree
-- adapters: python (pytest), go, rust (cargo test), vitest, jest
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
		"fredrikaverpil/neotest-golang",
		"rouge8/neotest-rust",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
	},
	keys = {
		{ "<leader>jt", function() require("neotest").run.run() end, desc = "run nearest test" },
		{ "<leader>jf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "run file" },
		{ "<leader>jA", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "run all" },
		{ "<leader>jl", function() require("neotest").run.run_last() end, desc = "run last" },
		{ "<leader>jd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "debug nearest" },
		{ "<leader>js", function() require("neotest").summary.toggle() end, desc = "summary" },
		{ "<leader>jo", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "output" },
		{ "<leader>jO", function() require("neotest").output_panel.toggle() end, desc = "output panel" },
		{ "<leader>jS", function() require("neotest").run.stop() end, desc = "stop" },
		{ "<leader>jw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "watch file" },
		{ "]j", function() require("neotest").jump.next({ status = "failed" }) end, desc = "next failed test" },
		{ "[j", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "prev failed test" },
	},
	config = function()
		local icons = require("config.icons").test
		local adapters = {}
		-- an adapter that fails to load (missing parser etc.) shouldn't take the rest down
		for _, spec in ipairs({
			{ "neotest-python", { dap = { justMyCode = false } } },
			{ "neotest-golang", {} },
			{ "neotest-rust", {} },
			{ "neotest-vitest", {} },
			{ "neotest-jest", {} },
		}) do
			local ok, adapter = pcall(require, spec[1])
			if ok then table.insert(adapters, adapter(spec[2])) end
		end
		require("neotest").setup({
			adapters = adapters,
			status = { virtual_text = true },
			output = { open_on_run = false },
			quickfix = { open = false },
			icons = {
				passed = vim.trim(icons.passed),
				failed = vim.trim(icons.failed),
				running = vim.trim(icons.running),
				skipped = vim.trim(icons.skipped),
				unknown = vim.trim(icons.unknown),
				watching = vim.trim(icons.watching),
			},
		})
	end,
}
