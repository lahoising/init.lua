local deps = require("dependencies")

local M = {}

function M.config()
  M.require()
  M.install_mods()
  M.setup_constants()
  M.setup_handlers()
end

function M.require()
  M.lspconfig = require("lspconfig")
  M.mason_lspconfig = require("mason-lspconfig")
  M.cmp_nvim_lsp = require("cmp_nvim_lsp")
end

function M.install_mods()
  local default_config_processor = function(default_config)
    return default_config
  end

  M.process_lsp_config = default_config_processor
  M.process_jdtls_lsp_config = default_config_processor

  local mod_exists, mod = pcall(require, "mods.lsp")
  if not mod_exists then return end
  M.process_lsp_config = mod.process_lsp_config or default_config_processor
  M.process_jdtls_lsp_config = mod.process_jdtls_lsp_config or default_config_processor
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
  local config = M.process_lsp_config({
    capabilities = M.capabilities,
  })
  M.lspconfig[server_name].setup(config)
end

function M.jdtls_handler()
  local JM = {}

  function JM.setup()
    JM.require()
    JM.load_constants()
    if not JM.mason_registry.is_installed("jdtls") then return end
    JM.load_base_config()
    JM.setup_jdtls()
  end

  function JM.require()
    JM.jdtls = require("jdtls")
    JM.mason_registry = require("mason-registry")
  end

  function JM.load_constants()
    JM.default_config = M.lspconfig.jdtls.config_def.default_config
  end

  function JM.load_base_config()
    local settings = {
      java = {
        completion = {
          enabled = true,
          importOrder = {
            "",
            "javax",
            "java",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 999,
            staticStarThreshold = 999,
          },
        },
      },
    }

    local cmd = JM.default_config.cmd
    local lombok_path = vim.env.HOME .. "/bin/lombok.jar"
    if vim.fn.filereadable(lombok_path) ~= 0 then
      table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_path)
    end

    JM.config = { settings = settings, cmd = cmd, }
  end

  function JM.setup_jdtls()
    vim.api.nvim_create_autocmd({ "Filetype" }, {
      callback = JM.on_filetype,
    })
  end

  function JM.on_filetype(event)
    local bufnr = event.buf
    if vim.bo[bufnr].filetype ~= "java" then return end
    JM.on_java_filetype(event)
  end

  function JM.on_java_filetype(event)
    local bufnr = event.buf

    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_dir = JM.default_config.root_dir(fname)

    local config = vim.tbl_deep_extend("force", JM.config, { root_dir = root_dir })
    config = M.process_jdtls_lsp_config(config)
    JM.jdtls.start_or_attach(config)
  end

  JM.setup()
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
