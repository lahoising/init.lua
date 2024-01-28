local lint = require("lint")
local language_tools = require("language-tools")

local linters_by_ft = {}
for language, config in pairs(language_tools.tools_by_language) do
	local linter = config.linter
	if linter.name ~= "" then
		linters_by_ft[language] = { linter.name }
	end
end

lint.linters_by_ft = linters_by_ft

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local expected_checkstyle_config_file = client.config.root_dir .. '/checkstyle.xml'
    if vim.fn.filereadable(expected_checkstyle_config_file) then
      lint.linters.checkstyle.config_file = expected_checkstyle_config_file
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		lint.try_lint()
	end,
})
