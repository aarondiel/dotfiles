local utils = require("utils")
local colors = require("colors")
local statusline_components = require("plugins.statusline_components")
local feline = utils.import("feline")

if feline == nil then
	return
end

local options = {
	default_colors = {
		foreground = colors.white,
		background = colors.darkgrey
	},

	components = {
		active = {
			left = {},
			middle = {},
			right = {}
		},

		inactive = {
			left = {},
			middle = {},
			right = {}
		}
	}
}

options.components.active.left = {
	statusline_components.vim_icon(colors.white, colors.darkgrey),
	statusline_components.separator("slant_right"),
	statusline_components.git_branch(colors.white, colors.green),
	statusline_components.separator("slant_right"),
	statusline_components.filename(colors.white, colors.cyan),
	statusline_components.separator("slant_right"),
	statusline_components.lsp_error(colors.white),
	statusline_components.lsp_warning(colors.white),
	statusline_components.lsp_hint(colors.white)
}

options.components.active.middle = {
	statusline_components.lsp_progress(colors.green)
}

options.components.active.right = {
	statusline_components.current_line(colors.white, colors.darkgrey),
	statusline_components.vim_mode(colors.white)
}

options.components.inactive.left = {
	statusline_components.filename(colors.lightgrey, colors.darkgrey)
}

local config = statusline_components.parse_options(options)
feline.setup(config)
