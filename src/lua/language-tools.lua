local M = {}

M.tools_by_language = {
	lua = {
		lsp = { name = 'lua_ls' },
		linter = { name = 'luacheck' },
		formatter = { name = 'stylua' },
	},
	cpp = {
		lsp = { name = 'clangd' },
		linter = { name = 'cpplint' },
		formatter = { name = 'clangformat', mason_name = 'clang-format' },
	},
	java = {
		lsp = { name = 'jdtls' },
		linter = { name = 'checkstyle' },
		formatter = { name = 'clangformat', mason_name = 'clang-format' },
	},
	rust = {
		lsp = { name = 'rust_analyzer' },
		linter = { name = '' },
		formatter = { name = '' },
	},
}

return M
