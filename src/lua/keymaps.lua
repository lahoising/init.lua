local jdtls = require("jdtls")

local M = {}

function M.setup_all_keymaps()
  M.setup_file_explorer_keymaps()
  M.setup_fuzzy_finder_keymaps()
  M.setup_git_keymaps()
  M.setup_diagnostics_navigation_keymaps()
  M.setup_formatter_keymaps()
  M.setup_lsp_on_attach()
end

function M.setup_file_explorer_keymaps()
  vim.keymap.set("n", "<leader>e", vim.cmd.Oil, { desc = "Open parent dir" })
end

function M.setup_fuzzy_finder_keymaps()
  local telescope_builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>/f", telescope_builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>/b", telescope_builtin.buffers, { desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>//", telescope_builtin.live_grep, { desc = "Telescope live grep" })
  vim.keymap.set("n", "<leader>/m", telescope_builtin.keymaps, { desc = "Telescope keymaps" })
  vim.keymap.set("n", "<leader>/d", telescope_builtin.diagnostics, { desc = "Telescope diagnostics" })

  vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { desc = "Telescope lsp references" })
  vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { desc = "Telescope definitions" })
  vim.keymap.set("n", "gf", telescope_builtin.lsp_document_symbols, { desc = "Telescope document symbols" })

  vim.keymap.set("n", "<leader>/h", telescope_builtin.command_history, { desc = "Telescope command history" })
  vim.keymap.set("n", "<leader>/s", telescope_builtin.spell_suggest, { desc = "Telescope spell suggest" })

  vim.keymap.set("n", "<leader>gs", M.get_git_status_fn({ telescope_builtin = telescope_builtin }),
    { desc = "Telescope git status" })
end

function M.get_git_status_fn(deps)
  return function()
    local current_open_file = vim.api.nvim_buf_get_name(0)
    local git_root = vim.fs.find({ ".git/..", }, {
      updward = true,
      type = "directory",
      path = current_open_file,
    })[1]

    deps.telescope_builtin.git_status({
      cwd = git_root,
    })
  end
end

function M.setup_git_keymaps()
  local gitsigns = require("gitsigns")
  local goto_next_hunk = function() gitsigns.nav_hunk('next') end
  local goto_prev_hunk = function() gitsigns.nav_hunk('prev') end

  vim.keymap.set("n", "<leader>gn", goto_next_hunk, { desc = "Git go to next hunk" })
  vim.keymap.set("n", "<leader>gp", goto_prev_hunk, { desc = "Git go to previous hunk" })
  vim.keymap.set("n", "<leader>gu", gitsigns.reset_hunk, { desc = "Git undo hunk" })
  vim.keymap.set("n", "<leader>gd", gitsigns.preview_hunk, { desc = "Git view hunk diff" })
  vim.keymap.set("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Git view hunk diff" })
end

function M.setup_diagnostics_navigation_keymaps()
  local diagnostic_goto_opts = {
    severity = { min = vim.diagnostic.severity.ERROR },
  }

  local goto_next_error = function()
    vim.diagnostic.goto_next(diagnostic_goto_opts)
  end

  local goto_prev_error = function()
    vim.diagnostic.goto_prev(diagnostic_goto_opts)
  end

  vim.keymap.set("n", "<leader>]", goto_next_error, { desc = "Diagnostic go to next" })
  vim.keymap.set("n", "<leader>[", goto_prev_error, { desc = "Diagnostic go to previous" })
end

function M.setup_formatter_keymaps()
  local conform = require("conform")
  local format_modifications = require("format-modifications").format_modifications

  vim.keymap.set("n", "<leader>fa", conform.format, { desc = "Format current file" })
  vim.keymap.set("n", "<leader>ff", format_modifications, { desc = "Format modifications on current file" })
end

function M.setup_lsp_on_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = M.on_lsp_attach,
  })
end

function M.on_lsp_attach(event)
  local opts = { buffer = event.buf }
  local merge_behavior = "force"

  vim.keymap.set("n",
    "K",
    vim.lsp.buf.hover,
    vim.tbl_deep_extend(merge_behavior, opts, { desc = "LSP display hover info" }))

  vim.keymap.set("n",
    "<leader>ca",
    vim.lsp.buf.code_action,
    vim.tbl_deep_extend(merge_behavior, opts, { desc = "LSP code action" }))

  vim.keymap.set("n",
    "<leader>r",
    vim.lsp.buf.rename,
    vim.tbl_deep_extend(merge_behavior, opts, { desc = "LSP rename" }))

  vim.keymap.set("n",
    "<leader>ge",
    vim.diagnostic.open_float,
    vim.tbl_deep_extend(merge_behavior, opts, { desc = "LSP open float" }))

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client.name == "jdtls" then
    M.on_jdtls_lsp_attach(event)
  end
end

function M.on_jdtls_lsp_attach(event)
  local opts = { buffer = event.buf }
  local merge_behavior = "force"

  vim.keymap.set("n",
    "<leader>fi",
    jdtls.organize_imports,
    vim.tbl_deep_extend(merge_behavior, opts, { desc = "JDTLS fix imports" }))
end

M.setup_all_keymaps()
