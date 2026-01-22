vim.bo.keywordprg = ":DefEng"
vim.bo.commentstring = "<!-- %s -->"
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.diagnostic.enable(false)
vim.treesitter.start()
