local utils = require("utils")
local telescope = utils.import("telescope")
local telescope_builtin = utils.import("telescope.builtin")

assert(telescope ~= nil, "could not import telescope")
assert(telescope_builtin ~= nil, "could not import telescope.builtin")

telescope.setup({})

utils.keymaps({
	{ "n", "<leader>ff", telescope_builtin.find_files },
	{ "n", "<leader>fg", telescope_builtin.live_grep },
	{ "n", "<leader>fb", telescope_builtin.buffers },
	{ "n", "<leader>fh", telescope_builtin.help_tags }
})
