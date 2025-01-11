local M = {}

function M.setup_all_keymaps()
  M.setup_file_explorer_keymaps()
  M.setup_fuzzy_finder_keymaps()
end

function M.setup_file_explorer_keymaps()
  vim.keymap.set("n", "<leader>e", vim.cmd.Oil, { desc = "Open parent dir" })
end

function M.setup_fuzzy_finder_keymaps()
  local telescope_builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>/f", telescope_builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>/b", telescope_builtin.buffers, { desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>//", telescope_builtin.live_grep, { desc = "Telescope live grep" })
  vim.keymap.set("n", "<leader>/m", telescope_builtin.keymaps, { desc = "Telescope keymaps" })
  vim.keymap.set("n", "<leader>/d", telescope_builtin.diagnostics, { desc = "Telescope diagnostics" })

  vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { desc = "Telescope lsp references" })
  vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { desc = "Telescope definitions" })
  vim.keymap.set("n", "gf", telescope_builtin.lsp_document_symbols, { desc = "Telescope document symbols" })

  vim.keymap.set("n", "<leader>/h", telescope_builtin.command_history, { desc = "Telescope command history" })
  vim.keymap.set("n", "<leader>/s", telescope_builtin.spell_suggest, { desc = "Telescope spell suggest" })

  -- TODO: add git status keymap
  -- vim.keymap.set("n", "<leader>/f", telescope_builtin.lsp_document_symbols, { desc = "Telescope find files" })
end

M.setup_all_keymaps()
