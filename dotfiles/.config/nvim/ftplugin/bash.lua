vim.bo.keywordprg = ":Man"
vim.opt_local.iskeyword:append("-")
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
