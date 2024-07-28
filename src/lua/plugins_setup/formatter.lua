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
    local cache = require("cache")
    local format_on_save_attribute_name = "format_on_save"
    local full_file_formatting_fallback_attribute_name = "full_file_formatting_fallback"

    local formatter_overrides = {
      ["clang-format"] = "clangformat",
    }

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
              local formatter_name = package_name
              if formatter_overrides[package_name] ~= nil then
                formatter_name = formatter_overrides[package_name]
              end
              specs_by_language[lang]["formatter"] = formatter_name
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
      local preconfigured_formatters_by_filetypes = require("formatter.filetypes")
      local formatters_by_filetype = {}
      for _, specs in pairs(specs_by_language) do
        if specs["filetypes"] ~= nil and specs["formatter"] ~= nil then
          for _, ft in ipairs(specs["filetypes"]) do
            if ft ~= nil and specs["formatter"] ~= nil then
              if preconfigured_formatters_by_filetypes[ft] ~= nil then
                local formatter_specs = preconfigured_formatters_by_filetypes[ft][specs["formatter"]]
                formatters_by_filetype[ft] = formatter_specs
              end
            end
          end
        end
      end
      return formatters_by_filetype
    end

    local specs_by_language = {
      GDScript = {
        filetypes = { "gd", "gdscript", "gdscript3" },
      },
    }

    for lang, specs in pairs(get_filetypes_and_formatters_per_language()) do
      if specs_by_language[lang] == nil then
        specs_by_language[lang] = {}
      end
      for key, val in pairs(specs) do
        specs_by_language[lang][key] = val
      end
    end

    local formatters_by_filetype = get_formatter_by_filetype(specs_by_language)

    local java_formatter_config = require("formatter.filetypes.java").clangformat()
    java_formatter_config.args = { "-style='{BasedOnStyle: Google, IndentWidth: 4}'", "--assume-filename=.java" }
    formatters_by_filetype["java"] = function()
      return java_formatter_config
    end

    for _, ft in ipairs(specs_by_language["GDScript"]["filetypes"]) do
      if formatters_by_filetype[ft] == nil then
        formatters_by_filetype[ft] = function()
          return { exe = "gdformat" }
        end
      end
    end

    formatters_by_filetype["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    }

    formatter.setup({
      filetype = formatters_by_filetype,
    })

    local cache_data = cache.read()
    vim.g.format_on_save = cache_data[format_on_save_attribute_name] == "true"
    vim.g.full_file_formatting_fallback = cache_data[full_file_formatting_fallback_attribute_name] == "true"

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
              if vim.g.full_file_formatting_fallback then
                vim.cmd("Format")
              else
                print("Not doing range based formatting, because the LSP does not support it")
              end
            end
          end
          vim.keymap.set("n", "<leader>ff", format, { buffer = bufnr })
          vim.keymap.set("n", "<leader>fa", "<Cmd>Format<CR>", { buffer = bufnr })

          vim.api.nvim_create_autocmd({ "BufWrite" }, {
            callback = function(write_event)
              if write_event.buf == bufnr and vim.g.format_on_save then
                format()
              end
            end,
          })
        end
      end,
    })

    vim.api.nvim_create_user_command("FormatOnSaveEnable", function()
      vim.g.format_on_save = true
      cache_data[format_on_save_attribute_name] = "true"
      cache.write(cache_data)
    end, {})

    vim.api.nvim_create_user_command("FormatOnSaveDisable", function()
      vim.g.format_on_save = false
      cache_data[format_on_save_attribute_name] = "false"
      cache.write(cache_data)
    end, {})

    vim.api.nvim_create_user_command("FullFileFormattingFallbackEnable", function()
      vim.g.full_file_formatting_fallback = true
      cache_data[full_file_formatting_fallback_attribute_name] = "true"
      cache.write(cache_data)
    end, {})

    vim.api.nvim_create_user_command("FullFileFormattingFallbackDisable", function()
      vim.g.full_file_formatting_fallback = false
      cache_data[full_file_formatting_fallback_attribute_name] = "false"
      cache.write(cache_data)
    end, {})
  end,
}
