local deps = require("dependencies")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    name = deps.tree_sitter,
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        additional_nvim_regex_highlighting = true,
      },
    },
  },
}
