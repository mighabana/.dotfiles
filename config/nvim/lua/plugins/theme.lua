return {
  "mighabana/night-owl.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    local night_owl = require("night-owl")

    night_owl.setup({
      bold = true,
      itelics = true,
      underline = true,
      undercurl = true,
      transparent_background = false,
    })
   
    vim.cmd.colorscheme("night-owl")
  end,
}
