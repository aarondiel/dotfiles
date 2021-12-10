local packer = require('plugins.packer_init')

packer.startup(function(use)
	use {
		'wbthomason/packer.nvim',
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('plugins.nvim-treesitter')
		end
	}

	use {
		'williamboman/nvim-lsp-installer'
	}

	use {
		'neovim/nvim-lspconfig',
		config = function()
			require('plugins.lspconfig')
		end
	}

	use {
		'onsails/lspkind-nvim',
		config = function()
			require('utils').import('lspkind', function(lspkind)
				lspkind.init()
			end)
		end
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			'kyazdani42/nvim-web-devicons',
			'nvim-treesitter/nvim-treesitter'
		}
	}

	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'neovim/nvim-lspconfig',
			'hrsh7th/vim-vsnip',
			'hrsh7th/cmp-vsnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-calc',
			'hrsh7th/cmp-buffer'
		}
	}

	use {
		'kyazdani42/nvim-tree.lua',
		requires = 'kyazdani42/nvim-web-devicons'
	}

	use {
		'nvim-treesitter/playground',
		requires = 'nvim-treesitter/nvim-treesitter'
	}

	use {
		'tpope/vim-fugitive'
	}
end)
