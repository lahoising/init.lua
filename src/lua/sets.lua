local M = {}

function M.setup()
  M.setup_global_opts()
  M.setup_lsp_attach_callback()
end

function M.setup_global_opts()
  vim.opt.rnu = true
  vim.opt.nu = true
  vim.opt.wrap = false
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.ignorecase = true
  vim.opt.incsearch = true
  vim.opt.scrolloff = 8
  vim.opt.signcolumn = "yes"
  vim.opt.shiftwidth = 2
  vim.opt.termguicolors = true
  vim.opt.fixeol = false

  vim.keymap.set("n", "<Space>", "<Nop>")
  vim.g.mapleader = " "
end

function M.setup_lsp_attach_callback()
  vim.api.nvim_create_autocmd({ "LspAttach" }, {
    callback = M.on_lsp_attach,
  })
end

function M.on_lsp_attach(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client.name == "gdscript" then
    M.on_gdscript_lsp_attach(event)
  end
end

function M.on_gdscript_lsp_attach(event)
  local bufnr = event.buf
  local buffer = vim.bo[bufnr]

  buffer.expandtab = true
end

M.setup()
