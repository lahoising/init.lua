local jdtls = require('jdtls')
local os_utils = require('os-utils')

local mregistry = os_utils.is_nixos() or require('mason-registry')

local M = {}

M.on_java_file_read = function()
  local jdtls_path = ''
  if not os_utils.is_nixos() then
    jdtls_path = vim.fs.find('jdtls', { path = mregistry.get_package('jdtls'):get_install_path() })
  end

	jdtls.start_or_attach({
    cmd = jdtls_path,
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw', 'build.xml' }, { upward = true })[1]),
	})

	vim.keymap.set('n', '<leader>fi', jdtls.organize_imports)
end

return M
