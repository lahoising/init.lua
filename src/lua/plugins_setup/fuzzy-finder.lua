local deps = require("dependencies")

local M = {}

function M.config()
  M.setup_telescope()
  M.setup_key_shortcuts()
end

function M.setup_telescope()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
      },
    },
  })
end

function M.setup_key_shortcuts()
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>/f", builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>/b", builtin.buffers, { desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>//", builtin.live_grep, { desc = "Telescope live grep" })
  vim.keymap.set("n", "<leader>/m", builtin.keymaps, { desc = "Telescope keymaps" })
  vim.keymap.set("n", "<leader>/d", builtin.diagnostics, { desc = "Telescope diagnostics" })

  vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope lsp references" })
  vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope definitions" })
  vim.keymap.set("n", "gf", builtin.lsp_document_symbols, { desc = "Telescope document symbols" })

  vim.keymap.set("n", "<leader>/h", builtin.command_history, { desc = "Telescope command history" })
  vim.keymap.set("n", "<leader>/s", builtin.spell_suggest, { desc = "Telescope spell suggest" })

  -- TODO: add git status keymap
  -- vim.keymap.set("n", "<leader>/f", builtin.lsp_document_symbols, { desc = "Telescope find files" })
end

return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    name = deps.telescope_fzf_native,
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      deps.telescope_fzf_native,
      deps.plenary,
      deps.tree_sitter,
    },
    config = M.config,
  },
}
