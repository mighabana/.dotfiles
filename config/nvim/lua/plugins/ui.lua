return {
  { -- status bar
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.settings.lualine")
    end,
  },
  { -- splash screen
    "goolord/alpha-nvim",
    config = function()
      -- require('plugins.settings.alpha')
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end,
  },
}
