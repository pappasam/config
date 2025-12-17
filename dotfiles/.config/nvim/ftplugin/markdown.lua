vim.bo.keywordprg = ":DefEng"
vim.bo.commentstring = "<!-- %s -->"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.diagnostic.enable(false)
vim.treesitter.start()
