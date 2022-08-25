require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = { "python", "html", "css", "svelte", "markdown" },
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "bash",
    "bibtex",
    "c",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "gdscript",
    "go",
    "gomod",
    "graphql",
    "hcl",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "julia",
    "kotlin",
    "latex",
    "ledger",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "ocaml",
    "php",
    "prisma",
    "python",
    "query",
    "regex",
    "rst",
    "ruby",
    "rust",
    "sql",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
})
require("nvim-treesitter.highlight").set_custom_captures({
  ["text.title.h1"] = "htmlH1",
  ["text.title.h2"] = "htmlH2",
  ["text.title.h3"] = "htmlH3",
  ["text.title.h4"] = "htmlH4",
  ["text.title.h5"] = "htmlH5",
  ["text.title.h6"] = "htmlH6",
})
