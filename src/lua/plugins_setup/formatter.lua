return {
	"joechrisellis/lsp-format-modifications.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mhartington/formatter.nvim",
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		local lsp_format_modifications = require("lsp-format-modifications")
		local mason_registry = require("mason-registry")
		local formatter = require("formatter")
		local mason_lspconfig_mappings = require("mason-lspconfig").get_mappings().mason_to_lspconfig
		local lspconfig = require("lspconfig")

		local function get_filetypes_and_formatters_per_language()
			local specs_by_language = {}
			for _, package_name in ipairs(mason_registry.get_installed_package_names()) do
				local package = mason_registry.get_package(package_name)
				for _, category in ipairs(package.spec.categories) do
					for _, lang in ipairs(package.spec.languages) do
						if category == "Formatter" then
							if specs_by_language[lang] == nil then
								specs_by_language[lang] = {}
							end
							specs_by_language[lang]["formatter"] = package_name
						elseif category == "LSP" then
							if specs_by_language[lang] == nil then
								specs_by_language[lang] = {}
							end
							local server_name = mason_lspconfig_mappings[package_name]
							local server = lspconfig[server_name]
							specs_by_language[lang]["filetypes"] = server.filetypes
						end
					end
				end
			end
			return specs_by_language
		end

		local function get_formatter_by_filetype(specs_by_language)
			local formatters_by_filetype = {}
			for _, specs in pairs(specs_by_language) do
				if specs["filetypes"] ~= nil and specs["formatter"] ~= nil then
					for _, ft in ipairs(specs["filetypes"]) do
						if ft ~= nil and specs["formatter"] ~= nil then
							local formatter_specs =
								require(string.format("formatter.filetypes.%s", ft))[specs["formatter"]]
							formatters_by_filetype[ft] = formatter_specs
						end
					end
				end
			end
			return formatters_by_filetype
		end

		local specs_by_language = get_filetypes_and_formatters_per_language()
		local formatters_by_filetype = get_formatter_by_filetype(specs_by_language)
		formatters_by_filetype["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		}

		formatter.setup({
			filetype = formatters_by_filetype,
		})

		vim.api.nvim_create_autocmd({ "LspAttach" }, {
			callback = function(event)
				local bufnr = event.buf
				for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
					local format = function() end
					if client.server_capabilities.documentRangeFormattingProvider then
						format = function()
							lsp_format_modifications.format_modifications(client, bufnr, {
								callback = function(_, _, range)
									formatter.format({}, {}, range["start"], range["end"])
								end,
								experimental_empty_line_handling = true,
							})
						end
					else
						format = function()
							print("Not doing range based formatting, because the LSP does not support it")
						end
					end
					vim.keymap.set("n", "<leader>ff", format, { buffer = bufnr })
					vim.keymap.set("n", "<leader>fa", "<Cmd>Format<CR>", { buffer = bufnr })
				end
			end,
		})
	end,
}
