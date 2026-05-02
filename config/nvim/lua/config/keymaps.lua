vim.keymap.set('n', '∆', '<cmd>m .+1<CR>==', { desc = 'Move line up' })
vim.keymap.set('n', '˚', '<cmd>m .-2<CR>==', { desc = 'Move line down' })
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { scope = "cursor" })
end, {desc = "Show diagnostics"})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })


-- telescope
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>")


-- disable nvim-surround defaults
vim.g.nvim_surround_no_normal_mappings = true

-- surround
vim.keymap.set("n", "gs", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding" })
vim.keymap.set("n", "gss", "<Plug>(nvim-surround-normal-cur)", { desc = "Add surrounding to line" })
vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding" })
vim.keymap.set("n", "gsc", "<Plug>(nvim-surround-change)", { desc = "Change surrounding" })
vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual)", { desc = "Add surrounding (visual)" })
