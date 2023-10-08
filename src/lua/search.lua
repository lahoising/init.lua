local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
			},
		},
	},
}

telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>/f', builtin.find_files, {})
vim.keymap.set('n', '<leader>//', builtin.live_grep, {})
vim.keymap.set('n', '<leader>/m', builtin.keymaps, {})
vim.keymap.set('n', '<leader>/r', builtin.lsp_references, {})
