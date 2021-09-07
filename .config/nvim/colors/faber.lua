local colors = {
	black = {'0', '#1e1818'},
	red = { '1', '#ef1f4f' },
	green = { '2', '#18a848' },
	yellow = { '3', '#ddcc22' },
	blue = { '4', '#4b7bfb' },
	magenta = { '5', '#e838e8' },
	cyan = { '6', '#38c9c9' },
	lighgrey = { '7', '#e3e3e3' },
	darkgrey = { '8', '#6d6464' },
	lightred = { '9', '#b0173b' },
	lightgreen = { '10', '#0e662c' },
	lightyellow = { '11', '#d2a212' },
	lightblue = { '12', '#274eb7' },
	lightmagenta = { '13', '#bd2dbd' },
	lightcyan = { '14', '#30B0B0' },
	white = { '15', '#b3b3b3' },
}

local highlight_groups = {
	{ group = 'String', style='italic', fg = colors.red, bg = nil }
}

for _, highlight_group in pairs(highlight_groups) do
	local highlight_options = {}

	if (highlight_group.style ~= nil) then
		highlight_options.cterm = highlight_group.style
		highlight_options.gui = highlight_group.style
	end

	if (highlight_group.fg ~= nil) then
		highlight_options.ctermfg = highlight_group.fg[1]
		highlight_options.guifg = highlight_group.fg[2]
	end

	if (highlight_group.bg ~= nil) then
		highlight_options.ctermbg = highlight_group.bg[1]
		highlight_options.guibg = highlight_group.bg[2]
	end

	vim.highlight.create(highlight_group.group, highlight_options, false)
end
