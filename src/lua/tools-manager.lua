-- NOTE: this just sets up the installer, but does not install anything.
-- The tools are installed in their respective tooling files,
-- e.g. LSPs are installed in lsp.lua

local mason = require("mason")
local mregistry = require("mason-registry")
local language_tools = require("language-tools")

mason.setup({})

local auto_install_tool_type = { linter = true, formatter = true }
local tools_by_ft = language_tools.tools_by_language
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local filetypes = client.config.filetypes
		for _, ft in ipairs(filetypes) do
			local tools_for_ft = tools_by_ft[ft]
			if tools_for_ft ~= nil then
				for tool_type, tool in pairs(tools_for_ft) do
					local tool_name = ""
					if tool.mason_name ~= nil then
						tool_name = tool.mason_name
					else
						tool_name = tool.name
					end

					if
						tool_name ~= nil
						and auto_install_tool_type[tool_type] == true
						and not mregistry.is_installed(tool_name)
					then
						vim.cmd("MasonInstall " .. tool_name)
					end
				end
			end
		end
	end,
})
