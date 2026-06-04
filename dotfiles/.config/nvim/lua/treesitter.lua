-- Native Tree-sitter language aliases. See :help treesitter

vim.treesitter.language.register("terraform", "terraform-vars")
vim.treesitter.language.register("bash", "shell")
vim.treesitter.language.register("json", "jsonc")

-- for big files, disable treesitter so we perform well
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function(args)
    local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
    if not stat then
      return
    end

    local avg = stat.size / vim.api.nvim_buf_line_count(args.buf)
    if stat.size < 5 * 1024 * 1024 and avg < 500 then
      return
    end

    vim.schedule(function()
      vim.api.nvim_buf_call(args.buf, function()
        pcall(vim.treesitter.stop, args.buf)
        vim.diagnostic.enable(false, { bufnr = args.buf })
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
          client:stop()
        end
        vim.bo.syntax = "off"
        vim.bo.undolevels = -1
        vim.o.undoreload = 0
        vim.wo.foldmethod = "manual"
        vim.wo.list = false
        vim.wo.spell = false
        vim.b.fast_buffer_guard = true
      end)
    end)
  end,
  desc = "Disable expensive features for big or long-line buffers",
})
