return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			mason_lspconfig.setup_handlers({
				function(server_name)
					if server_name == "jdtls" then
						-- JDTLS will be setup with a language specific lsp
						return
					end
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
			})

			lspconfig["gdscript"].setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					local pipe = "/tmp/godot.pipe"
					vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
					vim.opt.expandtab = false
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opts)
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			local mason_registry = require("mason-registry")
			local jdtls = require("jdtls")
			local jdtls_setup = require("jdtls.setup")
			local jdtls_server_name = "jdtls"

			if mason_registry.is_installed(jdtls_server_name) then
				local jdtls_package = mason_registry.get_package(jdtls_server_name)
				local jdtls_path = vim.fs.find("jdtls", { path = jdtls_package:get_install_path() })
				local home = os.getenv("HOME")
				local jvm_args = "--jvm-arg=-javaagent:" .. home .. "/bin/lombok.jar"

				vim.api.nvim_create_autocmd("FileType", {
					callback = function(event)
						local bufnr = event.buf
						if vim.bo[bufnr].filetype == "java" then
							local root_dir = jdtls_setup.find_root({ "gradlew", ".git", "mvnw", "build.xml" })

							vim.opt.tabstop = 4
							vim.opt.softtabstop = 4
							vim.opt.shiftwidth = 4

							local eclipse_workspace = home
								.. "/.local/share/eclipse/"
								.. vim.fn.fnamemodify(root_dir, ":p:h:t")

							local jdtls_cmd = {
								jdtls_path[1],
								jvm_args,
								"-data",
								eclipse_workspace,
							}

							local settings = {
								java = {
									completion = {
										enabled = true,
										importOrder = {
											"",
											"javax",
											"java",
											"import static",
										},
									},
									sources = {
										organizeImports = {
											starThreshold = 999,
											staticStarThreshold = 999,
										},
									},
								},
							}

							jdtls.start_or_attach({
								cmd = jdtls_cmd,
								root_dir = root_dir,
								settings = settings,
							})
						end
					end,
				})
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local bufnr = event.buf
					local ft = vim.bo[bufnr].filetype
					if ft == "java" then
						vim.keymap.set("n", "<leader>fi", jdtls.organize_imports, { buffer = bufnr })
					end
				end,
			})
		end,
	},
}
