vim.opt_local.iskeyword:append("$")
vim.bo.commentstring = "# %s"
vim.bo.comments = ":#"
vim.bo.formatoptions = "jcroql"
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
