local deps = require("dependencies")

local M = {}

function M.generate_opts()
  M.require()

  return {
    snippet = {
      expand = M.expand_snippet,
    },
    mapping = M.cmp.mapping.preset.insert({
      ["<C-j>"] = M.cmp.mapping.select_next_item(),
      ["<C-k>"] = M.cmp.mapping.select_prev_item(),
      ["<C-Spce>"] = M.cmp.mapping.complete(),
      ["<CR>"] = M.cmp.mapping.confirm({ select = true }),
    }),
    sources = M.cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
    })
  }
end

function M.require()
  M.cmp = require("cmp")
  M.luasnip = require("luasnip")
end

function M.expand_snippet(args)
  M.luasnip.lsp_expand(args.body)
end

return {
  "hrsh7th/nvim-cmp",
  name = deps.cmp,
  dependencies = {
    deps.cmp_nvim_lsp,
    deps.cmp_buffer,
    deps.cmp_path,
    deps.cmp_cmdline,
    deps.luasnip,
    deps.cmp_luasnip,
  },
  opts = M.generate_opts,
}
