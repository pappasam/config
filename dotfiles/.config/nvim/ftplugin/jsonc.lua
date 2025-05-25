vim.bo.commentstring = "// %s"
vim.bo.comments = "://"
vim.bo.formatoptions = "jcroql"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
