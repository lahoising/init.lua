local formatter_plug = require("formatter")
local formatter = require("formatter.format")
local general_formatter = require("formatter.filetypes.any")
local language_tools = require("language-tools")
local lsp_format_modifications = require("lsp-format-modifications")

local formatters_by_ft = {}
for ft, config in pairs(language_tools.tools_by_language) do
	local tool = config.formatter
  if tool.name ~= nil and tool.name ~= "" then
    formatters_by_ft[ft] = { require("formatter.filetypes." .. ft)[tool.name] }
  end
end

formatters_by_ft["*"] = {
	general_formatter.remove_trailing_whitespace,
}

formatter_plug.setup({
	filetype = formatters_by_ft,
})

vim.api.nvim_create_autocmd("BufWrite", {
	group = vim.api.nvim_create_augroup("UserFormatAutogroup", {}),
  callback = function(event)
    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = event.buf })) do
      lsp_format_modifications
          .format_modifications(client, event.buf, {
            callback = function(_, _, range)
              formatter.format({}, {}, range["start"], range["end"], {})
            end
          })
    end
  end,
})
