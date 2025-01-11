local deps = require("dependencies")

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
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    },
  },
}
