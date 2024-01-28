local os_utils = require('os-utils')

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
	-- theme
	{
		"ayu-theme/ayu-vim",
	},

	-- icons
	{
		"nvim-tree/nvim-web-devicons",
		config = true,
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		name = "telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"telescope-fzf-native.nvim",
		},
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
    tag = "v0.1.7",
	},

	-- java specific lsp
	{
		"mfussenegger/nvim-jdtls",
    tag = "0.2.0",
	},

	-- autocomplete
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"hrsh7th/cmp-path",
	},
	{
		"hrsh7th/cmp-cmdline",
	},
	{
		"hrsh7th/nvim-cmp",
    tag = "v0.0.1",
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
    tag = "v2.2.0",
	},
	{
		"saadparwaiz1/cmp_luasnip",
	},

	-- linter
	{
		"mfussenegger/nvim-lint",
	},

	-- formatter
	{
		"mhartington/formatter.nvim",
	},
  {
    "joechrisellis/lsp-format-modifications.nvim"
  },

	-- syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
    tag = "v0.9.1",
		build = ":TSUpdate",
	},

	-- terminal
	{
		"akinsho/toggleterm.nvim",
    tag = "v2.9.0",
	},

	-- git
	{
		"airblade/vim-gitgutter",
	},
	{
		"sindrets/diffview.nvim",
	},
}

-- conditionally installed plugins. Some of these don't work well with NixOS.
if not os_utils.is_nixos() then
  local extra_plugins = {
    -- lsp installer/manager
    {
      "williamboman/mason.nvim",
      tag = "v1.8.0",
    },
    {
      "williamboman/mason-lspconfig.nvim",
      tag = "v1.17.1",
    },
  }

  for _, plugin in ipairs(extra_plugins) do
    table.insert(plugins, plugin)
  end
end

require("lazy").setup(plugins)
