local utils = require('utils')

local function install_packer()
	local packer_install_dir = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

	vim.fn.delete(packer_install_dir, 'rf')
	vim.fn.system({
		'git',
		'clone',
		'https://github.com/wbthomason/packer.nvim',
		'--depth',
		'1',
		packer_install_dir
	})

	vim.cmd('packadd packer.nvim')

	return utils.import('packer', nil, function()
		error('could not clone packer')
	end)
end

local packer = utils.import('packer', nil, install_packer)

packer.init({
	display = {
		open_fn = function()
			return require('packer.util').float { border = 'single' }
		end,
		prompt_border = 'single'
	}
})

return packer
