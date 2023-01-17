require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      if lang == "javascript" then
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end
      return vim.api.nvim_buf_line_count(bufnr) > 50000
    end,
  },
  indent = {
    enable = true,
    disable = function(lang, bufnr)
      if lang == "python" then
        return true
      end
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "bash",
    "bibtex",
    "c",
    "c_sharp",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "gdscript",
    "go",
    "gomod",
    "graphql",
    "haskell",
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
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "ocaml",
    "php",
    "prisma",
    "python",
    "query",
    "r",
    "regex",
    "rst",
    "ruby",
    "rust",
    "sql",
    "svelte",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },
})
