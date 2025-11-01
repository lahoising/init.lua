local deps = require("dependencies")

local M = {}

function M.config()
  M.require()
  M.install_mods()
  M.setup_constants()
  M.setup_handlers()
end

function M.require()
  M.mason_lspconfig = require("mason-lspconfig")
  M.cmp_nvim_lsp = require("cmp_nvim_lsp")
end

function M.install_mods()
  M.process_lsp_config = function(_, default_config) return default_config end
  M.process_jdtls_lsp_config = function(default_config) return default_config end

  local mod_exists, mod = pcall(require, "mods.lsp")
  if not mod_exists then return end

  M.process_lsp_config = mod.process_lsp_config or M.process_lsp_config
  M.process_jdtls_lsp_config = mod.process_jdtls_lsp_config or M.process_jdtls_lsp_config
end

function M.setup_constants()
  M.capabilities = M.cmp_nvim_lsp.default_capabilities()
end

function M.setup_handlers()
  vim.lsp.config('*', {
    capabilities = M.capabilities,
  })

  for i, server_name in ipairs(M.mason_lspconfig.get_installed_servers()) do
    M.default_handler(server_name)
  end

  M.setup_additional_lsps()
end

function M.default_handler(server_name)
  local config = M.process_lsp_config(server_name, {})
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

function M.jdtls_handler()
  local JM = {}

  function JM.setup()
    JM.require()
    JM.load_constants()
    JM.load_base_config()
    JM.setup_jdtls()
  end

  function JM.require()
    JM.jdtls = require("jdtls")
  end

  function JM.load_constants()
    JM.default_config = {
      name = "jdtls",
      cmd = { "jdtls" },
      root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw', 'build.xml' }),
    }
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
            "#",
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

    M.set_buffer_opts(bufnr)

    local config = M.process_jdtls_lsp_config(JM.config)
    JM.jdtls.start_or_attach(config)
  end

  function M.set_buffer_opts(bufnr)
    local buffer = vim.bo[bufnr]
    buffer.tabstop = 4
    buffer.softtabstop = 4
    buffer.shiftwidth = 4
  end

  JM.setup()
end

function M.setup_additional_lsps()
  local additional_lsp_names = {
    "gdscript",
    "kotlin_language_server",
    "rust_analyzer",
    "jdtls",
    "lua_ls",
  }

  for _, server_name in ipairs(additional_lsp_names) do
    if server_name == "jdtls" then
      M.jdtls_handler()
    else
      M.default_handler(server_name)
    end
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
