return {
	{
		"akinsho/toggleterm.nvim",
		tag = "v2.9.0",
		config = function()
			local toggleterm = require("toggleterm")
			toggleterm.setup({
        size = 20,
				open_mapping = [[<C-\>]],
			})

			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = { "term://*" },
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("t", "<Escape>", "<C-Bslash><C-N>", opts)

					local term = require("toggleterm.terminal")
					local function get_terminals_and_focused_index()
						local terminals = term.get_all(true)
						local focused_terminal_idx = 1
						for idx, terminal in ipairs(terminals) do
							if terminal:is_focused() then
								focused_terminal_idx = idx
								break
							end
						end
						return terminals, focused_terminal_idx
					end

					local function open_next_terminal()
						local terminals, current_focused_terminal_idx = get_terminals_and_focused_index()
						terminals[current_focused_terminal_idx]:close()
						local next_idx = 1
						if #terminals >= current_focused_terminal_idx + 1 then
							next_idx = current_focused_terminal_idx + 1
						end
						terminals[next_idx]:open()
					end

					local function open_prev_terminal()
						local terminals, current_focused_terminal_idx = get_terminals_and_focused_index()
						terminals[current_focused_terminal_idx]:close()
						local prev_idx = #terminals
						if 1 <= current_focused_terminal_idx - 1 then
							prev_idx = current_focused_terminal_idx - 1
						end
						terminals[prev_idx]:open()
					end

					vim.keymap.set({ "n", "t" }, "<C-j>", open_next_terminal, opts)
					vim.keymap.set({ "n", "t" }, "<C-k>", open_prev_terminal, opts)
				end,
			})
		end,
	},
}
