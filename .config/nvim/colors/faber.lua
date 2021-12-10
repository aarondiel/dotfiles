local colors = {
	black = {'0', '#282a2e'},
	red = { '1', '#a54242' },
	green = { '2', '#8c9440' },
	yellow = { '3', '#de935f' },
	blue = { '4', '#5f819d' },
	magenta = { '5', '#85678f' },
	cyan = { '6', '#5e8d87' },
	lightgrey = { '7', '#707880' },
	darkgrey = { '8', '#373b41' },
	lightred = { '9', '#cc6666' },
	lightgreen = { '10', '#b5bd68' },
	lightyellow = { '11', '#f0c674' },
	lightblue = { '12', '#81a2be' },
	lightmagenta = { '13', '#b294bb' },
	lightcyan = { '14', '#8abeb7' },
	white = { '15', '#c5c8c6' },
}

local highlight_groups = {
	{ group='String', style='italic', fg=colors.lightmagenta, bg=nil },
	{ group='TSKeyword', style='italic', fg=colors.lightgreen, bg=nil },
	{ group='TSParameter', style=nil, fg=colors.blue, bg=nil },
	{ group='TSVariable', style=nil, fg=colors.lightblue, bg=nil },
	{ group='TSMethod', style=nil, fg=colors.lightmagenta, bg=nil },
	{ group='NormalFloat', style=nil, fg=colors.white, bg=colors.black },
	{ group='PMenu', style=nil, fg=colors.white, bg=colors.black },
	{ group='PMenuSel', style=nil, fg=colors.black, bg=colors.white },
	{ group='LineNr', style=nil, fg=colors.white, bg=nil },
	{ group='LineNrBelow', style=nil, fg=colors.lightgrey, bg=nil },
	{ group='LineNrAbove', style=nil, fg=colors.lightgrey, bg=nil },
	{ group='Comment', style=nil, fg=colors.lightgrey, bg=nil }
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
