local M = {}

function M.setup()
  M.require()
  M.config()
  M.setup_autocommands()
end

function M.require()
  M.jdtls = require("jdtls")
end

function M.config()
  vim.lsp.config("jdtls", {
    settings = {
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
  })

  local lombok_path = vim.env.HOME .. "/bin/lombok.jar"
  if vim.fn.filereadable(lombok_path) ~= 0 then
    vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. lombok_path
  end
end

function M.setup_autocommands()
  vim.api.nvim_create_autocmd({ "Filetype" }, {
    callback = M.on_filetype,
  })
end

function M.on_filetype(event)
  local bufnr = event.buf
  if vim.bo[bufnr].filetype ~= "java" then return end
  M.on_java_filetype(event)
end

function M.on_java_filetype(event)
  local bufnr = event.buf
  M.set_buffer_opts(bufnr)
end

function M.set_buffer_opts(bufnr)
  local buffer = vim.bo[bufnr]
  buffer.tabstop = 4
  buffer.softtabstop = 4
  buffer.shiftwidth = 4
end

return M
