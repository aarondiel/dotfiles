local utils = require("utils")
local feline = utils.import("feline")
local faber = utils.import("faber")
assert(feline ~= nil, "could not import feline")
assert(faber ~= nil, "could not import faber")

local colors = faber.get_true_colors()
local seperators = {
	block = "█",
	dot = "●",

	vertical_bar_thick = "┃",
	vertical_bar = "│",

	triangle_left = "",
	triangle_right = "",

	triangle_left_outline = "",
	triangle_right_outline = "",

	slant_bottom_right = "",
	slant_bottom_left = "",

	slant_top_right = "",
	slant_top_left = "",

	slant_right = "",
	slant_left = "",

	half_circle_left = "",
	half_circle = "",

	half_circle_outline = "",
	half_circle_left_outline = ""
}

local modes = {
	n = { hl = { fg = colors.white, bg = colors.black, name = "normal" }, str = " NORMAL " },
	i = { hl = { fg = colors.white, bg = colors.black, name = "insert" }, str = " INSERT " },
	R = { hl = { fg = colors.white, bg = colors.black, name = "replace" }, str = " REPLACE " },

	v = { hl = { fg = colors.white, bg = colors.black, name = "visual" }, str = " VISUAL " },
	V = { hl = { fg = colors.white, bg = colors.black, name = "visual_line" }, str = " VISUAL LINE " },
	[""] = { hl = { fg = colors.white, bg = colors.black, name = "visual_block" }, str = " VISUAL BLOCK " },

	s = { hl = { fg = colors.white, bg = colors.black, name = "select" }, str = " SELECT " },
	S = { hl = { fg = colors.white, bg = colors.black, name = "select_line" }, str = " SELECT LINE " },
	[""] = { hl = { fg = colors.white, bg = colors.black, name = "select_block" }, str = " SELECT BLOCK " },

	c = { hl = { fg = colors.white, bg = colors.black, name = "command" }, str = " COMMAND " },
	["!"] = { hl = { fg = colors.white, bg = colors.black, name = "command_executing" }, str = " COMMAND EXECUTING... " },
	t = { hl = { fg = colors.white, bg = colors.black, name = "terminal" }, str = " TERMINAL " },
	r = { hl = { fg = colors.white, bg = colors.black, name = "hit_enter_prompt" }, str = " HIT ENTER PROMPT " }
}

local function is_seperator(component)
	if type(component.provider) ~= "string" then
		return false
	end

	for _, sep in pairs(seperators) do
		if component.provider == sep then
			return true
		end
	end

	return false
end

local function get_component_highlight(component, fg_bg)
	if component == nil then
		return
	end

	if component.hl == nil then
		return
	end

	if type(component.hl) == "function" then
		local result = component.hl()

		return result[fg_bg]
	end

	return component.hl[fg_bg]
end

local function color_seperators(components)
	for i, component in ipairs(components) do
		if is_seperator(component) then
			local seperator_colors = {
				bg = get_component_highlight(components[i + 1], "bg"),
				fg = get_component_highlight(components[i - 1], "bg")
			}

			component.hl = utils.combine(seperator_colors, component.hl)
		end
	end

	return components
end

local function parse_components(components)
	return {
		active = {
			color_seperators(components.active.left),
			color_seperators(components.active.middle),
			color_seperators(components.active.right)
		},

		inactive = {
			color_seperators(components.inactive.left),
			color_seperators(components.inactive.middle),
			color_seperators(components.inactive.right)
		}
	}
end

local function seperator(sep, foreground, background)
	return {
		provider = sep,
		hl = { fg = foreground, bg = background }
	}
end

local function vim_icon(foreground, background)
	local component = {}

	component.name = "statusline_vim_icon"
	component.provider = "  "
	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function current_file(foreground, background)
	local component = {}

	function component.provider()
		local filename = vim.fn.expand("%:t")
		local extention = vim.fn.expand("%:e")
		local icon = utils.import("nvim-web-devicons", function(devicons)
			return devicons.get_icon(filename, extention)
		end)

		local result = " " .. filename .. " "

		if icon ~= nil then
			result = " " .. icon .. result
		end

		return result
	end

	component.name = "statusline_current_file"

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function vim_mode(foreground, background)
	local component = {}

	component.name = "statusline_vim_mode"

	function component.provider()
		local mode_info = vim.api.nvim_get_mode()
		local mode_settings = modes[mode_info.mode]

		if mode_settings == nil then
			return " ??? "
		end

		return mode_settings.str
	end

	function component.hl()
		local mode_info = vim.api.nvim_get_mode()
		local mode_settings = modes[mode_info.mode]

		if mode_settings == nil then
			return {
				fg = foreground,
				bg = background,
				name = component.name
			}
		end

		return {
			fg = mode_settings.hl.fg,
			bg = mode_settings.hl.bg,
			name = component.name .. mode_settings.hl.name
		}
	end

	return component
end

local function line_number(foreground, background)
	local component = {}

	component.name = "statusline_line_number"

	function component.provider()
		local line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")

		return "  " .. tostring(line) .. " / " .. total_lines .. " "
	end

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function column_number(foreground, background)
	local component = {}

	component.name = "statusline_column_number"

	function component.provider()
		local column = vim.fn.col(".")

		return "  " .. tostring(column) .. " "
	end

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function file_percentage(foreground, background)
	local component = {}

	component.name = "statusline_file_percentage"

	function component.provider()
		local line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")
		local percent = math.floor(100 * line / total_lines)

		if line == 1 then
			return " TOP "
		end

		if line == total_lines then
			return " BOTTOM "
		end

		return " " .. tostring(percent) .. "%% "
	end

	component.short_provider = ""

	component.hl = {
		fg = foreground,
		bg = background,
		component.name
	}

	return component
end

local function modified(foreground, background)
	local component = {}

	component.name = "statusline_modified"

	function component.provider()
		local file_modified = vim.api.nvim_get_option_value("modified", {})

		if file_modified then
			return "  "
		end

		return ""
	end

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function git_branch(foreground, background)
	local component = {}

	component.name = "statusline_git_branch"

	function component.provider()
		local branch_name = vim.b.gitsigns_head

		if branch_name == nil then
			return ""
		end

		return "  " .. branch_name .. " "
	end

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function lsp_errors(foreground, background)
	local component = {}

	component.name = "statusline_lsp_errors"

	function component.provider()
		local signs = vim.fn.sign_getdefined("DiagnosticSignError")
		local sign = signs[1]

		if sign == nil then
			return ""
		end

		local diagnostics = vim.diagnostic.get(
			0,
			{ severity = vim.diagnostic.severity.ERROR }
		)

		return " " .. sign.text .. tostring(#diagnostics) .. " "
	end

	component.short_provider = ""

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function lsp_warnings(foreground, background)
	local component = {}

	component.name = "statusline_lsp_warnings"

	function component.provider()
		local signs = vim.fn.sign_getdefined("DiagnosticSignWarn")
		local sign = signs[1]

		if sign == nil then
			return ""
		end

		local diagnostics = vim.diagnostic.get(
			0,
			{ severity = vim.diagnostic.severity.WARN }
		)

		return " " .. sign.text .. tostring(#diagnostics) .. " "
	end

	component.short_provider = ""

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function lsp_infos(foreground, background)
	local component = {}

	component.name = "statusline_lsp_infos"

	function component.provider()
		local signs = vim.fn.sign_getdefined("DiagnosticSignInfo")
		local sign = signs[1]

		if sign == nil then
			return ""
		end

		local diagnostics = vim.diagnostic.get(
			0,
			{ severity = vim.diagnostic.severity.INFO }
		)

		return " " .. sign.text .. tostring(#diagnostics) .. " "
	end

	component.short_provider = ""

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function lsp_hints(foreground, background)
	local component = {}

	component.name = "statusline_lsp_hints"

	function component.provider()
		local signs = vim.fn.sign_getdefined("DiagnosticSignHint")
		local sign = signs[1]

		if sign == nil then
			return ""
		end

		local diagnostics = vim.diagnostic.get(
			0,
			{ severity = vim.diagnostic.severity.HINT }
		)

		return " " .. sign.text .. tostring(#diagnostics) .. " "
	end

	component.short_provider = ""

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local function lsp_progress(foreground, background)
	local component = {}

	component.name = "statusline_lsp_progress"

	function component.provider()
		local progress = vim.lsp.util.get_progress_messages()[1]

		if progress == nil then
			return ""
		end

		local message = progress.message or ""
		local percentage = progress.percentage or 0
		local title = progress.title or ""
		local spinners = { "⠃", "⠉", "⠘", "⠰", "⠤", "⡄" }

		local ms = vim.loop.hrtime() / 1000000
		local frame = math.floor(ms / 120) % #spinners

		return string.format(
			" %%<%s %s %s (%s%%%%) ",
			spinners[frame + 1],
			title,
			message,
			percentage
		)
	end

	component.short_provider = ""

	component.hl = {
		fg = foreground,
		bg = background,
		name = component.name
	}

	return component
end

local components = {
	active = {
		left = {
			vim_icon(colors.green, colors.white),
			seperator(seperators.slant_bottom_left),
			current_file(colors.grey, colors.light_green),
			seperator(seperators.slant_top_left),
			modified(colors.grey, colors.green),
			seperator(seperators.slant_top_left),
			git_branch(colors.grey, colors.cyan),
			seperator(seperators.slant_top_left),
			vim_mode(colors.grey, colors.light_blue),
			seperator(seperators.triangle_right)
		},

		middle = {
			lsp_progress(colors.light_green, nil)
		},

		right = {
			lsp_hints(colors.light_blue, nil),
			lsp_infos(colors.light_grey, nil),
			lsp_warnings(colors.yellow, nil),
			lsp_errors(colors.red, nil),
			column_number(colors.grey, colors.light_red),
			line_number(colors.grey, colors.red),
			file_percentage(colors.grey, colors.light_cyan)
		}
	},

	inactive = {
		left = {
			vim_icon(colors.green, colors.white),
			seperator(seperators.slant_bottom_left),
			current_file(colors.white, colors.green),
			seperator(seperators.slant_top_left)
		},

		middle = {},

		right = {
			lsp_hints(colors.light_blue, nil),
			lsp_infos(colors.light_grey, nil),
			lsp_warnings(colors.yellow, nil),
			lsp_errors(colors.red, nil),
			line_number(colors.grey, colors.red)
		}
	}
}

feline.setup({
	theme = colors,
	default_fg = "white",
	default_bg = colors.grey,
	components = parse_components(components)
})
