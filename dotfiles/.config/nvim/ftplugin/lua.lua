vim.bo.keywordprg = ":help"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
