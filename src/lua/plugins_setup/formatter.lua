local deps = require("dependencies")

local M = {}

function M.config()
  M.require()
  M.setup_formatters()
  M.setup_autocmds()
end

function M.require()
  M.conform = require("conform")
  M.format_modifications = require("format-modifications").format_modifications
end

function M.setup_formatters()
  M.conform.setup({
    formatters_by_ft = {},
    default_format_opts = {
      lsp_format = "fallback",
    },
  })
end

function M.setup_autocmds()
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = M.format_modifications,
  })
end

return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      deps.lspconfig,
      deps.mason,
    },
    config = M.config,
  },
}
