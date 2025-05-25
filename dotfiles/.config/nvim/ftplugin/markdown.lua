vim.bo.commentstring = "<!-- %s -->"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
