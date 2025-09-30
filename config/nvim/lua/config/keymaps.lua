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



