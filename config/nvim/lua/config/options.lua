vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
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
