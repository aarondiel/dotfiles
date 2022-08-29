local utils = require("utils")
local dap = utils.import("dap")
local dapui = utils.import("dapui")
local dap_virtual_text = utils.import("nvim-dap-virtual-text")

assert(dap ~= nil, "could not import dap")
assert(dapui ~= nil, "could not import dapui")
assert(dap_virtual_text ~= nil, "could not import nvim-dap-virtual-text")

local function set_breakpoint_with_condition()
	dap.set_breakpoint(vim.fn.input("breakpoint condition: "))
end

local function set_log_point()
	dap.set_breakpoint(nil, nil, "log print message: ")
end

utils.keymaps({
	{ "n", "<f5>", dap.continue },
	{ "n", "<f10>", dap.step_over },
	{ "n", "<f11>", dap.step_into },
	{ "n", "<f12>", dap.step_out },
	{ "n", "<leader>b", dap.toggle_breakpoint },
	{ "n", "<leader>B", set_breakpoint_with_condition },
	{ "n", "<leader>L", set_log_point },
	{ "n", "<leader>dr", dap.repl.open },
	{ "n", "<leader>dl", dap.run_last },
	{ "n", "<leader>db", dapui.open }
})

dap.adapters.lldb = {
	type = "executable",
	command = "lldb-vscode",
	name = "lldb"
}

dap.configurations.c = { {
	name = "Launch",
	type = "lldb",
	request = "launch",
	program = function()
		return vim.fn.input("path to executable: ", vim.fn.getcwd() .. "/", "file")
	end,

	cwd = "${workspaceFolder}",
	stopOnEntry = false,
	args = {},
} }

dapui.setup()
dap_virtual_text.setup()
