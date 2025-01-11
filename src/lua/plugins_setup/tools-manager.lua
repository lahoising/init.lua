local deps = require("dependencies")

return {
  {
    "williamboman/mason.nvim",
    name = deps.mason,
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    name = deps.mason_lspconfig,
    dependencies = {
      deps.mason,
    },
    config = true,
  },
}
