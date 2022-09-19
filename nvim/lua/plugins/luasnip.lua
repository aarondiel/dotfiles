local utils = require("utils")
local luasnip = utils.import("luasnip")
assert(luasnip ~= nil, "could not import luasnip")

utils.keymap("i", "<c-k>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		return "<c-k>"
	end
end, { expr = true })

utils.keymap("i", "<c-j>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.jump(-1)
	else
		return "<c-j>"
	end
end, { expr = true })
