local deps = require("dependencies")
local lsp_jdtls = require("lsp.jdtls")

local M = {}

function M.config()
  M.require()
  M.setup_constants()
  M.setup_handlers()
end

function M.require()
  M.mason_lspconfig = require("mason-lspconfig")
  M.cmp_nvim_lsp = require("cmp_nvim_lsp")
end

function M.setup_constants()
  M.capabilities = M.cmp_nvim_lsp.default_capabilities()
end

function M.setup_handlers()
  vim.lsp.config('*', {
    capabilities = M.capabilities,
  })

  M.install_mods()
  for _, server_name in ipairs(M.mason_lspconfig.get_installed_servers()) do
    vim.lsp.enable(server_name)
  end

  M.setup_additional_lsps()
end

function M.install_mods()
  local mod_exists, mod = pcall(require, "mods.lsp")
  if not mod_exists or not mod.setup then return end
  mod.setup()
end

function M.setup_additional_lsps()
  local default_handler = function() end
  local additional_lsps = {
    gdscript = default_handler,
    kotlin_language_server = default_handler,
    rust_analyzer = default_handler,
    jdtls = lsp_jdtls.setup,
    lua_ls = default_handler,
  }

  for server_name, lsp_handler in pairs(additional_lsps) do
    lsp_handler()
    vim.lsp.enable(server_name)
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    name = deps.lspconfig,
    dependencies = {
      deps.mason,
      deps.mason_lspconfig,
      deps.cmp_nvim_lsp,
      deps.jdtls,
    },
    config = M.config,
  },
}
