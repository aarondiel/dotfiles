local utils = require("utils")
local first_install = false

local function install_packer()
	first_install = true
	local install_dir = vim.fn.stdpath("data") ..
		"/site/pack/packer/start/packer.nvim"

	vim.fn.delete(install_dir, "rf")
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		"--depth",
		"1",
		install_dir
	})

	vim.cmd("packadd packer.nvim")

	return utils.import("packer")
end

local packer = utils.import("packer", nil, install_packer)
assert(packer ~= nil, "could not clone packer")

packer.init({
	display = {
		prompt_border = "rounded",
		open_fn = utils.import("packer.util", function(packer_util)
			return packer_util.float
		end)
	}
})

packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("machakann/vim-sandwich")
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lua/plenary.nvim")

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({})
		end
	})

	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			local colorizer = require("colorizer")
			colorizer.setup()
		end
	})

	use({
		"kyazdani42/nvim-tree.lua",
		after = "nvim-web-devicons",
		config = function()
			require("plugins.nvim_tree")
		end
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		requires = "nvim-treesitter/playground",
		config = function()
			require("plugins/treesitter")
		end
	})

	use({
		"windwp/nvim-autopairs",
		after = "nvim-treesitter",
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				disable_in_macro = true,
				disable_in_visualblock = true,
				check_ts = true,
				enable_check_bracket_line = true
			})
		end
	})

	use({
		"nvim-treesitter/playground",
		after = "nvim-treesitter"
	})

	use({
		"andymass/vim-matchup",
		after = "nvim-treesitter",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end
	})

	use({
		"numToStr/Comment.nvim",
		after = "nvim-treesitter",
		config = function()
			require("plugins/comment")
		end
	})

	use("neovim/nvim-lspconfig")

	use({
		"williamboman/nvim-lsp-installer",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.lspinstaller")
		end
	})

	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-lsp-installer"
	})

	use({
		"hrsh7th/nvim-cmp",
		after = { "LuaSnip", "nvim-autopairs" },
		requires = {
			"onsails/lspkind.nvim",
			"lukas-reineke/cmp-under-comparator",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"davidsierradz/cmp-conventionalcommits",
			"tamago324/cmp-zsh"
		},

		config = function()
			require("plugins.lspconfig")
		end
	})

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		after = {
			"plenary.nvim",
			"nvim-treesitter",
			"nvim-web-devicons",
			"nvim-cmp"
		},

		config = function()
			require("plugins.telescope")
		end
	})

	use({
		"sindrets/diffview.nvim",
		config = function()
			local diffview = require("diffview")

			diffview.setup({
				enhanced_diff_hl = true,
				keymaps = {
					disable_defaults = true
				}
			})
		end
	})

	use({
		"TimUntersberger/neogit",
		after = { "plenary.nvim", "diffview.nvim" },
		config = function()
			local neogit = require("neogit")

			neogit.setup({
				integrations = { diffview = true }
			})
		end
	})

	use({
		"mfussenegger/nvim-dap",
		requires = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-telescope/telescope-dap.nvim"
		},

		config = function()
			require("plugins.dap")
		end
	})

	use({
		"aarondiel/faber-colorscheme",
		config = function()
			vim.cmd("colorscheme faber")
		end
	})

	use({
		"feline-nvim/feline.nvim",
		after = { "nvim-web-devicons", "gitsigns.nvim", "faber-colorscheme" },
		config = function()
			require("plugins.statusline")
		end
	})

	use({
		"aarondiel/spread.nvim",
		after = "nvim-treesitter",
		config = function()
			local spread = require("spread")
			local default_options = {
				silent = true,
				noremap = true
			}

			vim.keymap.set("n", "<leader>ss", spread.out, default_options)
			vim.keymap.set("n", "<leader>ssc", spread.combine, default_options)
		end
	})
end)

if first_install then
	packer.sync()
end
