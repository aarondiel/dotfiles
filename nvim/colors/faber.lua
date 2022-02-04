local colors = require('colors')

local highlight_groups = {
	{ group='String', style='italic', fg=colors.yellow, bg=nil },
	{ group='TSKeyword', style='italic', fg=colors.lightgreen, bg=nil },
	{ group='TSParameter', style=nil, fg=colors.blue, bg=nil },
	{ group='TSProperty', style=nil, fg=colors.cyan, bg=nil },
	{ group='TSOperator', style=nil, fg=colors.lightgreen, bg=nil },
	{ group='TSVariable', style=nil, fg=colors.lightblue, bg=nil },
	{ group='TSFunction', style=nil, fg=colors.lightred, bg=nil },
	{ group='TSKeywordFunction', style=nil, fg=colors.lightcyan, bg=nil },
	{ group='TSConditional', style=nil, fg=colors.red, bg=nil },
	{ group='TSMethod', style=nil, fg=colors.lightmagenta, bg=nil },
	{ group='TSConstructor', style=nil, fg=colors.white, bg=nil },
	{ group='TSPunctDelimiter', style=nil, fg=colors.white, bg=nil },
	{ group='TSPunctBracket', style=nil, fg=colors.lightcyan, bg=nil },
	{ group='TSParameter', style=nil, fg=colors.white, bg=nil },
	{ group='NormalFloat', style=nil, fg=colors.white, bg=colors.black },
	{ group='PMenu', style=nil, fg=colors.white, bg=colors.black },
	{ group='PMenuSel', style=nil, fg=colors.black, bg=colors.white },
	{ group='EndOfBuffer', style=nil, fg=colors.darkgrey, bg=nil },
	{ group='LineNr', style=nil, fg=colors.white, bg=nil },
	{ group='LineNrBelow', style=nil, fg=colors.lightgrey, bg=nil },
	{ group='LineNrAbove', style=nil, fg=colors.lightgrey, bg=nil },
	{ group='Comment', style=nil, fg=colors.lightgrey, bg=nil },
	{ group='ErrorMsg', style=nil, fg=colors.white, bg=colors.red }
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
