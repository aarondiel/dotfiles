-- see highlight-args E416 E417 E423
-- cterm: bold underline undercurl strikethrough reverse inverse italic standout nocombine NONE

local highlight_groups = {
	{ 'String', { cterm='italic', ctermfg = '9' } }
}

for _, highlight_group in pairs(highlight_groups) do
	local group_name = highlight_group[1]
	local group_options = highlight_group[2]

	vim.highlight.create(group_name, group_options, false)
end
