local utils = require("utils")
local cmp = utils.import("cmp")
local lspkind = utils.import("lspkind")
local luasnip = utils.import("luasnip")

assert(cmp ~= nil, "could not import cmp")
assert(lspkind ~= nil, "could not import lspkind")
assert(luasnip ~= nil, "could not import luasnip")

local function add_zsh_source()
	local group = utils.create_augroup("cmp_zsh_source")

	vim.api.nvim_create_autocmd("FileType", {
		desc = "add the completion source for zsh when entering a shellscript file",
		pattern = "sh",
		group = group,
		callback = function()
			cmp.setup.buffer({ sources = {
				{ name = "zsh" }
			}})
		end
	})
end

local function add_conventional_commits_source()
	local group = utils.create_augroup("")

	vim.api.nvim_create_autocmd("FileType", {
		desc = "add conventional commits source when entering a git commit",
		pattern = "gitcommit",
		group = group,
		callback = function()
			cmp.setup.buffer({ sources = {
				{ name = "conventionalcommits" }
			}})
		end
	})
end

local function tab_complete(fallback)
	if cmp.visible() then
		cmp.select_next_item()
		return
	end

	fallback()
end

local function shift_tab_complete(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
		return
	end

	fallback()
end

local function setup_autopairs(cmp_autopairs)
	cmp.event:on(
		"confirm_done",
		cmp_autopairs.on_confirm_done()
	)
end

local function replace_highlight_groups(highlight_groups)
	local result = {}

	for key, value in pairs(highlight_groups) do
		table.insert(result, key .. ":" .. value)
	end

	return table.concat(result, ",")
end

local function add_cmp_highlighting(faber)
	faber.highlight_groups({
		CmpPmenu = { link = "Normal" },
		CmpPmenuBorder = {
			fg = faber.colors.light_grey,
			bg = faber.colors.none,
			style = nil
		},

		CmpPmenuDocBorder = { link = "CmpPmenuBorder" }
	})
end

utils.import("nvim-autopairs.completion.cmp", setup_autopairs)

cmp.setup({
	window = {
		completion = {
			border = "rounded",
			winhighlight = replace_highlight_groups({
				Normal = "CmpPmenu",
				CursorLine = "PmenuSel",
				Search = "None",
				FloatBorder = "CmpPmenuBorder"
			})
		},

		documentation = {
			border = "rounded",
			winhighlight = replace_highlight_groups({
				Normal = "CmpPmenu",
				Search = "None",
				FloatBorder = "CmpPmenuDocBorder"
			})
		},
	},

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},

	mapping = {
		[ "<tab>" ] = cmp.mapping(tab_complete, { "i", "s", }),
    [ "<s-tab>" ] = cmp.mapping(shift_tab_complete, { "i", "s" }),

		[ "<c-u>" ] = cmp.mapping.scroll_docs(-4),
		[ "<c-d>" ] = cmp.mapping.scroll_docs(4),

		[ "<c-space>" ] = cmp.mapping.complete(),
		[ "<c-e>" ] = cmp.mapping.abort(),
		[ "<cr>" ] = cmp.mapping.confirm()
	},

	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer", keyword_length = 5 }
	},

	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol",
			menu = {},
			maxwidth = 20
		})
	},

	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			utils.import("cmp-under-comparator", function(under_comparator)
				return under_comparator.under
			end),
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order
		}
	}
})

add_zsh_source()
add_conventional_commits_source()
utils.import("faber", add_cmp_highlighting)
