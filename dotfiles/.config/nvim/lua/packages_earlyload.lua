require("snacks").setup({ -- https://github.com/folke/snacks.nvim {{{
  explorer = { enabled = true },
  gitbrowse = { enabled = true },
  image = { enabled = true },
  picker = {
    enabled = true,
    exclude = {
      "/__pycache__",
    },
    include = {
      "/.github/*",
      "/dotfiles/*",
      "/instance/*",
    },
  },
}) -- }}}
