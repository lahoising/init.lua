local formatter_plug = require("formatter")
local formatter = require("formatter.format")
local general_formatter = require("formatter.filetypes.any")
local language_tools = require("language-tools")
local lsp_format_modifications = require("lsp-format-modifications")
local utils = require("utils")

local formatters_by_ft = {}
for ft, config in pairs(language_tools.tools_by_language) do
	local tool = config.formatter
  if tool.name ~= nil and tool.name ~= "" then
    formatters_by_ft[ft] = function()
      local baseConfig = require("formatter.filetypes." .. ft)[tool.name]()
      if ft == "java" then
        baseConfig.args = { "-style='{BasedOnStyle: Google, IndentWidth: 4}'", "--assume-filename=.java" }
      end
      return baseConfig
    end
  end
end

formatters_by_ft["*"] = {
	general_formatter.remove_trailing_whitespace,
}

formatter_plug.setup({
	filetype = formatters_by_ft,
})

local function format(bufnr)
  for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
    local filetype = vim.bo[bufnr].filetype
    local filetypes_with_non_range_based_formatting_allowed = {
      "rust",
      "ruby",
    }
    local filetypes_with_formatting_disabled = {}
    if utils.array_contains_item(filetypes_with_non_range_based_formatting_allowed, filetype) then
      vim.cmd("Format")
    elseif not utils.array_contains_item(filetypes_with_formatting_disabled, filetype) then
      lsp_format_modifications.format_modifications(client, bufnr, {
        callback = function(_, _, range)
          formatter.format({}, {}, range["start"], range["end"], {})
        end,
      })
    end
  end
end

vim.keymap.set("n", "<leader>f", function()
  local bufnr = vim.api.nvim_get_current_buf()
  format(bufnr)
end)
