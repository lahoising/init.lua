local function go_to_position(row, col)
	print(string.format("row %d, col %d", row, col))
	vim.cmd(string.format("%d", row, col))
end

local function go_to_next_diagnostic()
	local next_diagnostic_position = vim.diagnostic.get_next_pos()
	go_to_position(next_diagnostic_position[1] + 1, next_diagnostic_position[2])
end

local function go_to_prev_diagnostic()
	local prev_diagnostic_position = vim.diagnostic.get_prev_pos()
	go_to_position(prev_diagnostic_position[1] + 1, prev_diagnostic_position[2])
end

vim.keymap.set("n", "<leader>]", go_to_next_diagnostic, {})
vim.keymap.set("n", "<leader>[", go_to_prev_diagnostic, {})

return {}
