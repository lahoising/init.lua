local default_theme = "onenord"

return {
  {
    "rmehri01/onenord.nvim",
    tag = "v0.7.0",
    lazy = (default_theme ~= "onenord"),
    config = function() 
      vim.cmd([[colorscheme onenord]]) 
    end
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = (default_theme ~= "nordic"),
    config = function() 
      vim.cmd([[colorscheme nordic]]) 
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = (default_theme ~= "kanagawa"),
    config = function() 
      vim.cmd([[colorscheme kanagawa]]) 
    end
  },
  {
    "Shatur/neovim-ayu",
    lazy = (default_theme ~= "ayu"),
    config = function()
      require("ayu").setup({ mirage = true })
      vim.cmd([[colorscheme ayu]])
    end
  },
  {
    "xiyaowong/transparent.nvim",
    opts = {},
  }
}
