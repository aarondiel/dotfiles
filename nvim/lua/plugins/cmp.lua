local utils = require("utils")
local cmp = utils.import("cmp")
local lspkind = utils.import("lspkind")

assert(cmp ~= nil, "could not import cmp")
assert(lspkind ~= nil, "could not import lspkind")

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

local function setup_autopairs(cmp_autopairs)
	cmp.event:on(
		"confirm_done",
		cmp_autopairs.on_confirm_done()
	)
end

utils.import(
	"nvim-autopairs.completion.cmp",
	setup_autopairs
)

cmp.setup({
	snippet = {
		expand = function(args)
			local luasnip = utils.import("luasnip")

			if luasnip == nil then
				return
			end

			luasnip.lsp_expand(args.body)
		end
	},

	mapping = {
		[ '<tab>' ] = cmp.mapping.select_next_item({
			behavior = cmp.SelectBehavior.Insert
		}),

		[ '<s-tab>' ] = cmp.mapping.select_prev_item({
			behavior = cmp.SelectBehavior.Insert
		}),

		[ '<c-b>' ] = cmp.mapping.scroll_docs(-4),
		[ '<c-f>' ] = cmp.mapping.scroll_docs(4),

		[ '<c-e>' ] = cmp.mapping.abort(),
		[ '<cr>' ] = cmp.mapping.confirm()
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
			maxwidth = 50
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
