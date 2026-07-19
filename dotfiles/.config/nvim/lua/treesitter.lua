-- Native Tree-sitter language aliases. See :help treesitter

vim.treesitter.language.register("terraform", "terraform-vars")
vim.treesitter.language.register("bash", "shell")
vim.treesitter.language.register("json", "jsonc")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
  callback = function(event)
    local language =
      vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
    if language and vim.treesitter.query.get(language, "indents") then
      vim.bo[event.buf].indentexpr =
        "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
