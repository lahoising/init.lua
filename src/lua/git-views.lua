local diffview = require("diffview")
local actions = require("diffview.actions")

diffview.setup({
	keymaps = {
		view = {
			{ "n", "<Esc><Esc>", actions.close, { desc = "Close the diff view" } },
		},
		file_panel = {
			{ "n", "<Esc><Esc>", ":DiffviewClose<CR>", { desc = "Close the diff view" } },
		},
	},
})

vim.keymap.set("n", "<leader>gd", ":GitGutterPreviewHunk<CR>")
vim.keymap.set("n", "<leader>gu", ":GitGutterUndoHunk<CR>")
vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>")
