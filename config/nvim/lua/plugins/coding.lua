return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "python",
          "lua",
          "bash",
          "sql",
          "json",
          "yaml",
          "markdown"
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {"williamboman/mason.nvim"},
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ruff",
          "bashls",
          "lua_ls",
          "jsonls",
          "terraformls",
          "pyright"
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" }
    }
  },
  { -- interactive repl 
    "Vigemus/iron.nvim",
    config = function()
      require("plugins.settings.iron")
    end,
  }
}
