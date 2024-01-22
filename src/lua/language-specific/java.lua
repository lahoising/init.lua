local jdtls = require('jdtls')
local os_utils = require('os-utils')

local mregistry = os_utils.is_nixos() or require('mason-registry')

local M = {}

M.on_lsp_attach = function()
	local jdtls_path = '' 
  if not os_utils.is_nixos() then 
    jdtls_path = mregistry.get_package('jdtls'):get_install_path() 
  end
	jdtls.start_or_attach({
		cmd = { jdtls_path },
	})

	vim.keymap.set('n', '<leader>fi', jdtls.organize_imports)
end

return M
