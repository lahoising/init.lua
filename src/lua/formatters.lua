local formatter = require("formatter")
local general_formatter = require("formatter.filetypes.any")
local language_tools = require("language-tools")

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

formatter.setup({
	filetype = formatters_by_ft,
})

vim.keymap.set("n", "<leader>f", ":Format<CR>")

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("UserFormatAutogroup", {}),
	command = "Format",
})
