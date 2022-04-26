local module = {}

local utils = require("utils")
local colors = require("colors")
local lsp_provider = utils.import("feline.providers.lsp")

--- @alias Color string[]

--- @param foreground Color
--- @param background Color
--- @return table
function module.vim_icon(foreground, background)
	local component = {}

	component.provider = ""

	component.icon = {
		str = "  ",
		always_visible = true
	}

	component.hl = {
		fg = foreground[2],
		bg = background[2]
	}

	return component
end

--- @param foreground Color
--- @param background Color
--- @return table
function module.filename(foreground, background)
	local component = {}

	function component.provider()
		return " " .. vim.fn.expand("%:t") .. " "
	end

	function component.icon()
		local filename = vim.fn.expand("%:t")
		local extention = vim.fn.expand("%:e")

		return utils.import("nvim-web-devicons", function(devicons)
			local icon = devicons.get_icon(filename, extention)

			if icon == nil then
				return ""
			end

			return " " .. icon
		end)
	end

	component.hl = {
		fg = foreground[2],
		bg = background[2]
	}

	return component
end

--- @param foreground Color
--- @return table
function module.lsp_error(foreground)
	local component = {}

	if lsp_provider == nil then
		component.enabled = false

		return component
	end

	component.provider = "diagnostic_errors"

	function component.enabled()
		return lsp_provider.diagnostics_exist(vim.diagnostic.severity.ERROR)
	end

	component.hl = { fg = foreground[2] }
	component.icon = "  "

	return component
end

--- @param foreground Color
--- @return table
function module.lsp_warning(foreground)
	local component = {}

	if lsp_provider == nil then
		component.enabled = false

		return component
	end

	component.provider = "diagnostic_warnings"

	function component.enabled()
		return lsp_provider.diagnostics_exist(vim.diagnostic.severity.WARN)
	end

	component.hl = { fg = foreground[2] }
	component.icon = " ⚠ "

	return component
end

--- @param foreground Color
--- @return table
function module.lsp_hint(foreground)
	local component = {}

	if lsp_provider == nil then
		component.enabled = false

		return component
	end

	component.provider = "diagnostic_hints"

	function component.enabled()
		return lsp_provider.diagnostics_exist(vim.diagnostic.severity.HINT)
	end

	component.hl = { fg = foreground[2] }
	component.icon = "  "

	return component
end

--- @param foreground Color
--- @return table
function module.lsp_progress(foreground)
	local component = {}

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

	component.hl = { fg = foreground[2] }

	return component
end

--- @param foreground Color
--- @param background Color
--- @return table
function module.git_branch(foreground, background)
	local component = {}

	component.provider = "git_branch"
	component.right_sep = {
		str = " ",
		hl = {
			fg = foreground[2],
			bg = background[2]
		}
	}

	component.hl = {
		fg = foreground[2],
		bg = background[2]
	}

	component.icon = "  "

	return component
end

--- @param foreground Color
--- @param background Color
--- @return table
function module.current_line(foreground, background)
	local component = {}

	function component.provider()
		local current_line = vim.fn.line(".")
		local total_lines = vim.fn.line("$")

		if current_line == 1 then
			 return " top "
		elseif current_line == total_lines then
			 return " bottom "
		end

		local result = math.floor(100 * current_line / total_lines)
		return " " .. tostring(result) .. "%%" .. " "
	end

	component.icon = "  "

	component.hl = {
		fg = foreground[2],
		bg = background[2]
	}

	return component
end

--- @param foreground Color
--- @return table
function module.vim_mode(foreground)
	local component = {}

	local modes = {
		["n"] = { "NORMAL", colors.red },
		["no"] = { "N-PENDING", colors.red },
		["i"] = { "INSERT", colors.magenta },
		["ic"] = { "INSERT", colors.magenta },
		["t"] = { "TERMINAL", colors.green },
		["v"] = { "VISUAL", colors.cyan },
		["V"] = { "V-LINE", colors.cyan },
		[""] = { "V-BLOCK", colors.cyan },
		["R"] = { "REPLACE", colors.yellow },
		["Rv"] = { "V-REPLACE", colors.yellow },
		["s"] = { "SELECT", colors.lightblue },
		["S"] = { "S-LINE", colors.lightblue },
		[""] = { "S-BLOCK", colors.lightblue },
		["c"] = { "COMMAND", colors.lightmagenta },
		["cv"] = { "COMMAND", colors.lightmagenta },
		["ce"] = { "COMMAND", colors.lightmagenta },
		["r"] = { "PROMPT", colors.blue },
		["rm"] = { "MORE", colors.blue },
		["r?"] = { "CONFIRM", colors.blue },
		["!"] = { "SHELL", colors.green }
	}

	function component.provider()
		local mode = modes[vim.fn.mode()]
		local mode_name = mode[1]

		return " " .. mode_name .. " "
	end

	function component.hl()
		local mode = modes[vim.fn.mode()]
		local mode_color = mode[2]

		return {
			fg = foreground[2],
			bg = mode_color[2]
		}
	end

	return component
end

--- @param type "vertical_bar" | "vertical_bar_thin" | "left" | "right" | "block" | "left_filled" | "right_filled" | "slant_left" | "slant_left_thin" | "slant_right" | "slant_right_thin" | "slant_left_2" | "slant_left_2_thin" | "slant_right_2" | "slant_right_2_thin" | "left_rounded" | "left_rounded_thin" | "right_rounded" | "right_rounded_thin" | "circle"
--- @param foreground? Color
--- @param background? Color
--- @return table
function module.separator(type, foreground, background)
	local component = {}

	if foreground ~= nil then
		foreground = foreground[2]
	end

	if background ~= nil then
		foreground = foreground[2]
	end

	component.provider = type

	component.hl = {
		fg = foreground,
		bg = background
	}

	return component
end

--- @param provider string
--- @return boolean
local function is_separator(provider)
	if type(provider) ~= "string" then
		return false
	end

	local possible_separator_types = {
		"vertical_bar",
		"vertical_bar_thin",
		"left",
		"right",
		"block",
		"left_filled",
		"right_filled",
		"slant_left",
		"slant_left_thin",
		"slant_right",
		"slant_right_thin",
		"slant_left_2",
		"slant_left_2_thin",
		"slant_right_2",
		"slant_right_2_thin",
		"left_rounded",
		"left_rounded_thin",
		"right_rounded",
		"right_rounded_thin",
		"circle"
	}

	return vim.fn.index(
		possible_separator_types,
		provider
	) ~= -1
end

--- @param components table
--- @param side "right" | "left"
--- @param default_color Color
--- @return table
local function parse_components(components, side, default_color)
	local result_components = {}

	for i, component in ipairs(components) do
		local color_before = default_color[2]
		local color_after = default_color[2]

		if not is_separator(component.provider) then
			goto continue
		end

		if components[i-1] ~= nil then
			color_before = components[i-1].hl.bg
		end

		if components[i+1] ~= nil then
			color_after = components[i+1].hl.bg
		end

		if component.hl.fg == nil then
			component.hl.fg = color_before
		end

		if component.hl.bg == nil then
			component.hl.bg = color_after
		end

		if side == "right" then
			component.right_sep = {
				str = component.provider,
				always_visible = true,
				hl = {
					bg = component.hl.bg,
					fg = component.hl.fg
				}
			}
		elseif side == "left" then
			component.left_sep = {
				str = component.provider,
				always_visible = true,
				hl = {
					bg = component.hl.bg,
					fg = component.hl.fg
				}
			}
		end

		component.provider = ""

		::continue::

		table.insert(
			result_components,
			component
		)
	end

	return result_components
end

--- @class ComponentTable
--- @field left table
--- @field middle table
--- @field right table

--- @class Components
--- @field active ComponentTable
--- @field inactive ComponentTable

--- @class ColorOptions
--- @field foreground Color
--- @field background Color

--- @class Options
--- @field default_colors table
--- @field components Components

--- @param options Options
--- @return table
function module.parse_options(options)
	return {
		theme = {
			fg = options.default_colors.foreground[2],
			bg = options.default_colors.background[2]
		},

		components = {
			active = {
				parse_components(
					options.components.active.left,
					"left",
					options.default_colors.background
				),
				options.components.active.middle,
				parse_components(
					options.components.active.right,
					"right",
					options.default_colors.background
				)
			},

			inactive = {
				parse_components(
					options.components.inactive.left,
					"left",
					options.default_colors.background
				),
				options.components.inactive.middle,
				parse_components(
					options.components.inactive.right,
					"right",
					options.default_colors.background
				)
			}
		}
	}
end

return module
