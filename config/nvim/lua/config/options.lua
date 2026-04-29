vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  command = "setlocal tabstop=4 shiftwidth=4 expandtab",
})

vim.api.nvim_set_option("clipboard", "unnamed")

vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = "rounded",
    float = {
      border = "rounded",
      source = "always",
      focusable = false,
      header = "",
      prefix = "● ",
    },
  }
})

vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.local/share/nvim/undo")

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}


-- # Folding
-- save and load views on startup
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  command = "silent! mkview",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    -- small defeer lets ufo initialise first
    vim.defer_fn(function()
      vim.cmd("silent! loadview")
    end, 0)
  end,
})

-- only save and load folds
vim.opt.viewoptions = { "folds" }

-- remove foldcolumn indicators
vim.opt.foldcolumn = "0"
