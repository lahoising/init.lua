local lint = require("lint")
local language_tools = require("language-tools")
local mregistry = require("mason-registry")

local linters_by_ft = {}
for language, config in pairs(language_tools.tools_by_language) do
	local linter = config.linter
	if linter.name ~= "" then
		linters_by_ft[language] = { linter.name }
	end
end

lint.linters_by_ft = linters_by_ft

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		lint.try_lint()
	end,
})
