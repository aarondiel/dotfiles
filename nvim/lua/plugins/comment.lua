local utils = require("utils")
local comment = utils.import("Comment")
assert(comment ~= nil, "could not import Commet")

comment.setup({
	toggler = {
		line = 'gcc',
		block = 'gbc',
	},

	opleader = {
		line = 'gc',
		block = 'gb',
	},

	extra = {
		above = 'gcO',
		below = 'gco',
		eol = 'gcA',
	},
})
