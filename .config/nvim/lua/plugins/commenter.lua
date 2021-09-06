_G.commenter_comment_visual = function()
	vim.api.nvim_command('visual')
	local line_pos = { vim.fn.line("'<"), vim.fn.line("'>") }
	print(vim.inspect(line_pos))
	table.sort(line_pos)

	local lines = vim.api.nvim_buf_get_lines(0, line_pos[1] - 1, line_pos[2], 1)

	for i = 1, #lines do
		lines[i] = '\t' .. lines[i]
	end

	lines = vim.fn.insert(lines, '/*')
	lines[#lines + 1] = '*/'

	vim.api.nvim_buf_set_lines(0, line_pos[1] - 1, line_pos[2], 1, lines)
end
