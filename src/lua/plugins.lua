-- bootstrap lazy.nvim - the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- fuzzy finder
	{ 
		'nvim-telescope/telescope-fzf-native.nvim', 
		name = 'telescope-fzf-native.nvim',
		build = 'make',
	},
	{ 
		'nvim-telescope/telescope.nvim', 
		branch = '0.1.x', 
		dependencies = { 
			'nvim-lua/plenary.nvim', 
			'telescope-fzf-native.nvim',
		} 
	},

	-- lsp
	{
		'williamboman/mason.nvim',
		tags = 'v1.8.0',
	},
	{
		'williamboman/mason-lspconfig.nvim',
		tags = 'v1.17.1',
	},
	{
		'neovim/nvim-lspconfig',
		tags = 'v0.1.6',
	},

	-- java specific lsp
	{
		'mfussenegger/nvim-jdtls',
		tags = '0.2.0'
	}
}

require("lazy").setup(plugins)
