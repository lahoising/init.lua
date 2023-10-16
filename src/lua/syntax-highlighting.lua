local treesitter = require("nvim-treesitter.configs")
local language_tools = require("language-tools")

local languages = {}
for lang, _ in pairs(language_tools.tools_by_language) do
	table.insert(languages, lang)
end

treesitter.setup({
	ensure_installed = languages,
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
