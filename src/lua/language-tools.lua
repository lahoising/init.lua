local M = {}

M.tools_by_language = {
	lua = {
		lsp = { name = "lua_ls" },
		linter = { name = "luacheck" },
		formatter = { name = "stylua" },
	},
	cpp = {
		lsp = { name = "clangd" },
		linter = { name = "cpplint" },
		formatter = { name = "clangformat", mason_name = "clang-format" },
	},
	java = {
    lsp = {},
		linter = { name = "checkstyle" },
		formatter = { name = "clangformat", mason_name = "clang-format" },
	},
	rust = {
		lsp = { name = "rust_analyzer" },
		linter = {},
		formatter = {},
	},
	zig = {
		lsp = { name = "zls" },
		linter = {},
		formatter = {},
	},
}

return M
