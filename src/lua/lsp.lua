local tools = require('language-tools')
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

local lsps = {}

for _,tools_map in pairs(tools.tools_by_language) do
	table.insert(lsps, tools_map.lsp.name)
end

mason_lspconfig.setup {
	automatic_installation = true,
}

local language_specific_configs_path = 'language-specific.'
local language_specific_configs = {
	java = {
		on_attach = require(language_specific_configs_path .. 'java').on_lsp_attach,
	},
}

for _, lsp in ipairs(lsps) do
	lspconfig[lsp].setup {}
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(event)
		local bufnr = event.buf
		local opts = { buffer = bufnr }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>ge', vim.diagnostic.open_float, opts)

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local filetypes = client.config.filetypes
		for _, ft in ipairs(filetypes) do
			print(vim.inspect(ft))
			local language_config = language_specific_configs[ft]
			if (language_config ~= nil and language_config.on_attach ~= nil) then
				language_config.on_attach()
			end
		end
	end,
})
