return {
  { -- telescope (search tool)
    'nvim-telescope/telescope.nvim',
    keys = require("config.plugin_keymaps").telescope,
    cmd = { "Telescope" },
    config = function()
      require("plugins.settings.telescope")
    end,
    dependencies = {
      'nvim-telescope/telescope-file-browser.nvim', 'nvim-lua/plenary.nvim', {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").load_extension("ui-select")
        end,
      }
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = require("config.plugin_keymaps").comments,
    event = "BufReadPost",
    opts = {}
  },
  { -- TODO: plugin
    "folke/todo-comments.nvim",
    keys = require("config.plugin_keymaps").todo_comments,
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  { -- highlight indentations
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  { -- autopairs
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- opts = {},
  },
  { -- which key (motion helper)
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  { -- Quality of Life plugins for Neovim
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
    },
  },
  { -- show Git changes in line
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  }
}
