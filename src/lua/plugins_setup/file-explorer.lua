local deps = require("dependencies")

local M = {}

function M.config()
  local oil = require("oil")
  oil.setup()

  vim.keymap.set("n", "<leader>e", vim.cmd.Oil, { desc = "Open parent dir" })
end

return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      deps.icons,
    },
    config = M.config,
  },
}
