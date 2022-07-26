-- Telescope.nvim configuration
local ts = require("telescope")
local actions = require("telescope.actions")

ts.setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".git",
      ".venv",
    },
    layout_config = {
      vertical = { width = 0.90 },
    },
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
      },
    },
    prompt_prefix = " ",
  },
})
