vim.bo.tabstop = 4
vim.bo.softtabstop = 0
vim.bo.shiftwidth = 0
vim.bo.expandtab = false
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
