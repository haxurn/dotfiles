-- debugger: nvim-dap + UI + inline variable values.
-- mason-nvim-dap installs adapters and sets default launch configs:
--   python (debugpy), rust/c/c++ (codelldb), go (delve), js/ts (js-debug-adapter)
-- A project .vscode/launch.json is picked up automatically.
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
			opts = {},
			config = function(_, opts)
				local dap, dapui = require("dap"), require("dapui")
				dapui.setup(opts)
				-- open the UI when a session starts, close it when it ends
				dap.listeners.after.event_initialized.dapui_config = function() dapui.open({}) end
				dap.listeners.before.event_terminated.dapui_config = function() dapui.close({}) end
				dap.listeners.before.event_exited.dapui_config = function() dapui.close({}) end
			end,
		},
		{ "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = { "mason-org/mason.nvim" },
			opts = {
				automatic_installation = true,
				ensure_installed = { "python", "codelldb", "delve", "js" },
				handlers = {}, -- default setup for every installed adapter
			},
		},
	},
	keys = {
		{ "<F9>", function() require("dap").continue() end, desc = "debug: continue / start" },
		{ "<F10>", function() require("dap").step_over() end, desc = "debug: step over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "debug: step into" },
		{ "<F12>", function() require("dap").step_out() end, desc = "debug: step out" },
		{ "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "toggle breakpoint" },
		{ "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("condition: ")) end, desc = "conditional breakpoint" },
		{ "<leader>Dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("log message: ")) end, desc = "log point" },
		{ "<leader>Dc", function() require("dap").continue() end, desc = "continue / start" },
		{ "<leader>DC", function() require("dap").run_to_cursor() end, desc = "run to cursor" },
		{ "<leader>Dr", function() require("dap").restart() end, desc = "restart" },
		{ "<leader>Dt", function() require("dap").terminate() end, desc = "terminate" },
		{ "<leader>Du", function() require("dapui").toggle({}) end, desc = "toggle UI" },
		{ "<leader>De", function() require("dapui").eval() end, mode = { "n", "x" }, desc = "eval expression" },
		{ "<leader>DR", function() require("dap").repl.toggle() end, desc = "toggle REPL" },
		{ "<leader>DF", function() require("fzf-lua").dap_breakpoints() end, desc = "list breakpoints" },
	},
	config = function()
		local icons = require("config.icons")
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		for name, sign in pairs(icons.dap) do
			vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] })
		end
		-- .vscode/launch.json may contain comments / trailing commas
		local vscode = require("dap.ext.vscode")
		local json = require("plenary.json")
		vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
	end,
}
