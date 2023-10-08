local M = {}

M.tools_by_language = {
	lua = {
		lsp = { name = 'lua_ls' },
		linter = { name = 'luacheck' },
		formatter = { name = '' },
	},
	cpp = {
		lsp = { name = 'clangd' },
		linter = { name = 'cpplint' },
		formatter = { name = '' },
	},
	java = {
		lsp = { name = 'jdtls' },
		linter = { name = 'checkstyle' },
		formatter = { name = '' },
	},
	rust = {
		lsp = { name = 'rust_analyzer' },
		linter = { name = '' },
		formatter = { name = '' },
	},
}

return M
