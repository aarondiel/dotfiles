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

packer.startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"kyazdani42/nvim-tree.lua",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("plugins.configs.nvim_tree")
		end
	})
end)

if first_install then
	packer.sync()
end
