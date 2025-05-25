vim.wo.foldenable = false
vim.wo.list = false
vim.bo.keywordprg = ":DefEng"
vim.treesitter.start()

if vim.fn.winnr("$") > 1 then
  vim.cmd.wincmd("T")
end
