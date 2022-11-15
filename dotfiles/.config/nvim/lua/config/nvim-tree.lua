require("nvim-tree").setup({
  renderer = {
    full_name = true,
  },
  filters = {
    dotfiles = false,
  },
  view = {
    mappings = {
      list = {
        { key = "c", action = "close_node" },
      },
    },
  },
})
