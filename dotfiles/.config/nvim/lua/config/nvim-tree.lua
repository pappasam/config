require("nvim-tree").setup({
  renderer = {
    full_name = true,
  },
  filters = {
    dotfiles = true,
    exclude = {
      "/dotfiles",
    }
  },
})
