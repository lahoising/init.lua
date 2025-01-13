local deps = require("dependencies")

return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      deps.lspconfig,
      deps.mason,
    },
    opts = {
      formatters_by_ft = {},
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
