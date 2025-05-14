return {
  { -- status bar
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.settings.lualine")
    end,
  }
}
