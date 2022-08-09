require("zen-mode").setup({
  window = {
    width = 79,
    options = {
      signcolumn = "no",
      wrap = true,
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
      foldcolumn = "0",
      colorcolumn = "0",
      list = false,
    },
  },
  plugins = {
    twilight = { enabled = false },
  },
})
