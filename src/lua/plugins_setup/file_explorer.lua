return {
	{
		"nvim-tree/nvim-tree.lua",
		tag = "v0",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local nvim_tree = require("nvim-tree")

			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			nvim_tree.setup({
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
			})

			vim.keymap.set("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", {})
		end,
	},
}
