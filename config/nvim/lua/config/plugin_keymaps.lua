local M = {}

M.telescope = {
  {
    "<leader>ff",
    "<cmd>Telescope find_files<cr>",
    mode = "n",
    desc = "Find files",
  },
  {
    "<leader>fb",
    "<cmd>Telescope file_browser<cr>",
    mode = "n",
    desc = "File browser",
  },
  {
    "<leader>b",
    "<cmd>Telescope buffers<cr>",
    mode = "n",
    desc = "Find buffers",
  },
  {
    "<leader>fg",
    "<cmd>Telescope git_files<cr>",
    mode = "n",
    desc = "Find git files"
  },
  {
    "<leader>fd",
    "<cmd>Telescope diagnostics<cr>",
    mode = "n",
    desc = "LSP diagnostics",
  },
  {
    "<leader>fl",
    "<cmd>Telescope live_grep<cr>",
    mode = "n",
    desc = "Find words",
  },
  {
    "<leader>fs",
    "<cmd>Telescope grep_string<cr>",
    mode = "n",
    desc = "Find word under the cursor",
  }
}

M.todo_comments = {
  {
    "gcmh",
    function()
      vim.cmd("norm gcO HACK: ")
      vim.cmd("startinsert")
    end,
    mode = "n",
    desc = "Create a hack comment",
  },
  {
    "gcmn",
    function()
      vim.cmd("norm gcO NOTE: ")
      vim.cmd("startinsert")
    end,
    mode = "n",
    desc = "Create a note comment",
  },
  {
    "gcmt",
    function()
      vim.cmd("norm gcO TODO: ")
      vim.cmd("startinsert")
    end,
    mode = "n",
    desc = "Create a todo comment",
  },
  {
    "gcmf",
    function()
      vim.cmd("norm gcO FIX: ")
      vim.cmd("startinsert")
    end,
    mode = "n",
    desc = "Create a fix comment",
  },
  {
    "gcmb",
    function()
      vim.cmd("norm gcO BUG: ")
      vim.cmd("startinsert")
    end,
    mode = "n",
    desc = "Create a bug comment",
  },
  {
    "]t",
    function()
      require("todo-comments").jump_next()
    end,
    mode = "n",
    desc = "Next todo comment",
  },
  {
    "[t",
    function()
      require("todo-comments").jump_prev()
    end,
    mode = "n",
    desc = "Previous todo comment",
  },
}

M.comments = {
  {
    "gcy",
    function()
      vim.cmd("norm yy")
      vim.vmd("norm gcc")
    end,
    mode = "n",
    desc = "Yank and comment",
  }
}

return M
