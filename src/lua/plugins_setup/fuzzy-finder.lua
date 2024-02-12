return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    branch = "0.1.x",
    config = function(opts)
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>/f", builtin.find_files)
      vim.keymap.set("n", "<leader>/b", builtin.buffers)
      vim.keymap.set("n", "<leader>//", builtin.live_grep)
      vim.keymap.set("n", "<leader>/m", builtin.keymaps)

      vim.keymap.set("n", "gr", builtin.lsp_references)
      vim.keymap.set("n", "gd", builtin.lsp_definitions)
      vim.keymap.set("n", "gf", builtin.lsp_document_symbols)

      vim.keymap.set("n", "<leader>gd", builtin.git_status)

      vim.keymap.set("n", "<leader>h", builtin.command_history)
      vim.keymap.set("n", "<leader>ss", builtin.spell_suggest)
    end,
  },
}
