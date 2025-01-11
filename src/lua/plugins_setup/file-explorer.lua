local deps = require("dependencies")

return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      deps.icons,
    },
    config = true,
  },
}
