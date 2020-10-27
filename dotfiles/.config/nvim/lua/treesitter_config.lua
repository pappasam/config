require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent    = { enable = true },
  textobjects = { enable = true },
  ensure_installed = {
    'html',
    'javascript',
    'rust',
    'python',
    'query',
    'tsx',
    'typescript',
  },
})
