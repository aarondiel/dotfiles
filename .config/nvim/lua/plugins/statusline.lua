local utils = require('utils')
local colors = require('colors')

local feline = utils.import('feline')

if feline == nil then
	return
end

local seperators = {
	left = '',
	right = ''
}

local components = {
	active = { {}, {}, {} },
	inactive = { {}, {}, {} }
}

-- vim icon
table.insert(components.active[1], {
	provider = '  ',

	hl = {
		fg = colors.white[2],
		bg = colors.lightred[2]
	},

	right_sep = {
		str = seperators.right,
		hl = {
			fg = colors.lightred[2],
			bg = colors.red[2]
		}
	}
})

-- filename with icon
table.insert(components.active[1], {
	provider = function()
		local result = ' '

		local filename = vim.fn.expand('%:t')
		local extention = vim.fn.expand('%:e')

		utils.import('nvim-web-devicons', function(devicons)
			local icon = devicons.get_icon(filename, extention)

			if icon == nil then
				return
			end

			result = result .. icon .. ' '
		end)

		result = result .. filename .. ' '

		return result
	end,

	hl = {
		fg = colors.white[2],
		bg = colors.red[2]
	},

	right_sep = {
		str = seperators.right
	}
})

utils.import('feline.providers.lsp', function(lsp)
	-- lsp errors
	table.insert(components.active[1], {
		provider = "diagnostic_errors",
		enabled = function()
				return lsp.diagnostics_exist('Error')
		end,

		hl = { fg = colors.red[2] },
		icon = "  "
	})

	-- lsp warnings
	table.insert(components.active[1], {
		provider = "diagnostic_warnings",
		enabled = function()
			return lsp.diagnostics_exist('Warning')
		end,

		hl = { fg = colors.red[2] },
		icon = " ⚠ ",
	})

	-- lsp hints
	table.insert(components.active[1], {
		provider = "diagnostic_hints",
		enabled = function()
			return lsp.diagnostics_exist('Hint')
		end,

		hl = { fg = colors.red[2] },
		icon = "  "
	})
end)

table.insert(components.active[2], {
	provider = function()
		local lsp = vim.lsp.util.get_progress_messages()[1]

		if lsp then
			local msg = lsp.message or ''
			local percentage = lsp.percentage or 0
			local title = lsp.title or ''
			local spinners = {
				'⠃',
				'⠉',
				'⠘',
				'⠰',
				'⠤',
				'⡄'
			}

			local success_icon = {
				'',
				'',
				'',
			}

			local ms = vim.loop.hrtime() / 1000000
			local frame = math.floor(ms / 120) % #spinners

			if percentage >= 70 then
				return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
			end

			return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
		end

		return ''
	end,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(winid) > 80
	end,
	hl = { fg = colors.green[2] }
})

feline.setup({
	colors = {
		fg = colors.white[2],
		bg = colors.black[2]
	},
	components = components
})
