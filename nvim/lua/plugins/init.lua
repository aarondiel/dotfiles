local utils = require("utils")
local new_install = false

local function install_packer()
	local packer_install_dir = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	new_install = true

	vim.fn.delete(packer_install_dir, "rf")
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		"--depth",
		"1",
		packer_install_dir
	})

	vim.cmd("packadd packer.nvim")

	return utils.import("packer", nil, function()
		error("could not clone packer")
	end)
end

local packer = utils.import("packer", nil, install_packer)

packer.init({
	display = {
		prompt_border = "single",
		open_fn = function()
			return require("packer.util").float { border = "single" }
		end
	}
})

packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("tpope/vim-fugitive")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = "nvim-treesitter/playground",
		config = function()
			require("plugins.nvim-treesitter")
		end
	})


	use({
		"neovim/nvim-lspconfig",
		requires = "williamboman/nvim-lsp-installer",

		config = function()
			require("plugins.lspconfig")
		end
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim"
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua"
		}
	})

	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("plugins.nvim_tree")
		end
	})

	use({
		"famiu/feline.nvim",
		config = function()
			require("plugins.statusline")
		end
	})

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugins.gitsigns")
		end
	})
end)

if new_install then
	packer.sync()
end
