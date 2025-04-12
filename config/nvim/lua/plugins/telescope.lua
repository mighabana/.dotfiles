return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

    require('telescope').setup{
      defaults = {
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-h>"] = "which_key"
          },
          n = {
            ["<C-h>"] = "which_key"
          }
        },
      }
    }
  end
}
