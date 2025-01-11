local deps = require("dependencies")

local M = {}

function M.config()
  M.require()
  M.setup_constants()
  M.setup_handlers()
end

function M.require()
  M.lspconfig = require("lspconfig")
  M.mason_lspconfig = require("mason-lspconfig")
  M.cmp_nvim_lsp = require("cmp_nvim_lsp")
end

function M.setup_constants()
  M.capabilities = M.cmp_nvim_lsp.default_capabilities()
end

function M.setup_handlers()
  M.mason_lspconfig.setup_handlers({
    M.default_handler,
    ["jdtls"] = M.jdtls_handler,
  })
end

function M.default_handler(server_name)
  M.lspconfig[server_name].setup({
    capabilities = M.capabilities,
  })
end

function M.jdtls_handler()
  -- TODO: setup jdtls with nvim-jdtls
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      deps.mason,
      deps.mason_lspconfig,
      deps.cmp_nvim_lsp
    },
    config = M.config,
  },
}
