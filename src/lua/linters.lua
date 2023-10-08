local lint = require('lint')
local language_tools = require('language-tools')
local mregistry = require('mason-registry')

local linters_by_ft = {}
for language, config in pairs(language_tools.tools_by_language) do
  local linter = config.linter
  if linter.name ~= '' then
    linters_by_ft[language] = { linter.name }
  end
end

lint.linters_by_ft = linters_by_ft

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local filetypes = client.config.filetypes
		for _, ft in ipairs(filetypes) do
			local linters_for_ft = linters_by_ft[ft]
			if linters_for_ft ~= nil then
        for _, linter in ipairs(linters_for_ft) do
          if not mregistry.is_installed(linter) then
            vim.cmd('MasonInstall ' .. linter)
          end
        end
			end
		end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    lint.try_lint()
  end,
})
