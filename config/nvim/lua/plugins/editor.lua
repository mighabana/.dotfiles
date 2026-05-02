local fold_state_saved = false

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
  },
  { -- code folding with LSP/treesitter
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        local ftMap = {
          python = { "lsp", "treesitter" },
          lua    = { "lsp", "treesitter" },
          json   = { "treesitter", "indent" },
          yaml   = { "indent" },
          toml   = { "indent" },
        }
        return ftMap[filetype] or { "treesitter", "indent" }
      end,
    },
    init = function()
      -- These must be set before the plugin loads
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99  -- start with all folds open
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      {
        "zm", function()
          if not fold_state_saved then
            vim.cmd("silent! mkview 9")
            vim.opt.foldlevel = 1
            fold_state_saved = true
          end
        end, desc = "Fold to depth 1 (save state)"
      },
      {
        "zr", function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          vim.cmd("silent! loadview 9")
          vim.api.nvim_win_set_cursor(0, cursor)
          fold_state_saved = false
        end, desc = "Restore fold state"
      },
      -- open/close everything
      { "<leader>zo", function() require("ufo").openAllFolds() end,  desc = "Open all folds" },
      { "<leader>zc", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold or hover",
      },
    },
  },
  { -- filesytem editing
    'nvim-mini/mini.files',
    version = '*',
    keys = {
      { "<leader>e", function() require("mini.files").open() end, desc = "Open file explorer" },
      { "<leader>E", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Open file explorer (current file)" },
    },
    opts = {
      mappings = {
        close         = "q",
        go_in         = "l",
        go_in_plus    = "L",
        go_out        = "h",
        go_out_plus   = "H",
        mark_goto     = "'",
        mark_set      = "m",
        reset         = "<BS>",
        reveal_cwd    = "@",
        show_help     = "g?",
        synchronize   = "=",
        trim_left     = "<",
        trim_right    = ">",
      },
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 50,
      },
    },
  },
}
