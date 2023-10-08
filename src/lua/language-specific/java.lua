local jdtls = require('jdtls')
local mregistry = require('mason-registry')

local M = {}

M.on_lsp_attach = function()
	local jdtls_path = mregistry.get_package('jdtls'):get_install_path()
	jdtls.start_or_attach({
		cmd = { jdtls_path },
	})

	vim.keymap.set('n', '<leader>fi', jdtls.organize_imports)
end

return M
