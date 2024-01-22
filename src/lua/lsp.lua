local tools = require("language-tools")
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")
local os_utils = require("os-utils")

local mason_lspconfig = os_utils.is_nixos or require("mason-lspconfig")

local lsps = {}

for _, tools_map in pairs(tools.tools_by_language) do
	table.insert(lsps, tools_map.lsp.name)
end

if not os_utils.is_nixos() then
	mason_lspconfig.setup({
		automatic_installation = true,
	})
end

local language_specific_configs_path = "language-specific."
local language_specific_configs = {
	java = {
		on_attach = require(language_specific_configs_path .. "java").on_lsp_attach,
	},
}

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Enter>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

local capabilities = cmp_nvim_lsp.default_capabilities()
for _, lsp in ipairs(lsps) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(event)
		local bufnr = event.buf
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opts)

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local filetypes = client.config.filetypes
		for _, ft in ipairs(filetypes) do
			local language_config = language_specific_configs[ft]
			if language_config ~= nil and language_config.on_attach ~= nil then
				language_config.on_attach()
			end
		end
	end,
})
