-- Telescope.nvim configuration
local ts = require('telescope')
local actions = require('telescope.actions')

ts.setup({
  defaults = {
    prompt_prefix = " ",
    layout_strategy = "vertical",
    layout_config = {
      vertical = { width = 0.90 },
    },
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
})
