local M = {}

M.tools_by_language = {
	lua = {
		lsp = { name = 'lua_ls' },
		linter = { name = '' },
		formatter = { name = '' },
	},
	cpp = {
		lsp = { name = 'clangd' },
		linter = { name = '' },
		formatter = { name = '' },
	},
	java = {
		lsp = { name = 'jdtls' },
		linter = { name = '' },
		formatter = { name = '' },
	},
	rust = {
		lsp = { name = 'rust_analyzer' },
		linter = { name = '' },
		formatter = { name = '' },
	},
}

return M
