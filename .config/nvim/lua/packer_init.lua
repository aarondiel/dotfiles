local packer_present, packer = pcall(require, 'packer')
local sync_pending = false
local packer_install_dir = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
require('plugins.commenter')

if not packer_present then
	local repository = 'wbthomason/packer.nvim'
	local git_dest = string.format(
		'https://github.com/%s',
		repository
	)

	vim.fn.delete(packer_install_dir, 'rf')
	vim.fn.system({ 'git', 'clone', git_dest, packer_install_dir })
	sync_pending = true

	vim.cmd('packadd packer.nvim')

	packer_present, packer = pcall(require, 'packer')
	if not packer_present then
		error('could not clone packer')
	end
end

packer.init {
	display = {
		open_fn = function()
			return require('packer.util').float { border = 'single' }
		end,
		prompt_border = 'single'
	}
}

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
		'kabouzeid/nvim-lspinstall',
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
			local lspkind_present, lspkind = pcall(require, 'lspkind')
			if not lspkind_present then
				return
			end

			lspkind.init()
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
			'hrsh7th/cmp-nvim-lsp',
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

if sync_pending then
	vim.cmd('PackerSync')
else
	vim.cmd('PackerInstall')
end
