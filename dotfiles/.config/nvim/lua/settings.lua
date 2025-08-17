-- Neovim options. See :help option-list
-- 'tabline' {{{

function _G.custom_tabline()
  local result = {}
  for i = 1, vim.fn.tabpagenr("$") do
    if i == vim.fn.tabpagenr() then
      table.insert(result, "%#TabLineSel#")
    else
      table.insert(result, "%#TabLine#")
    end
    table.insert(result, "%" .. i .. "T") -- BEGIN clickable region %{tabnr}T
    table.insert(result, " " .. i .. " ") -- set number
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local tabfilename
    local icon, _, is_default = MiniIcons.get("filetype", "")
    if bufname:match("^term://") then
      local command = bufname:match("term://.-//[0-9]+:(.+)")
      if command then
        local first_word = command:match("([^%s]+)")
        if first_word then
          local last_part = first_word:match("([^/]+)$") or first_word
          tabfilename = "[" .. last_part .. "]"
          icon, _ = MiniIcons.get("filetype", "terminal")
        else
          tabfilename = "[term]"
          icon, _ = MiniIcons.get("filetype", "terminal")
        end
      else
        tabfilename = "[term]"
        icon, _ = MiniIcons.get("filetype", "terminal")
      end
    else
      tabfilename = vim.fn.fnamemodify(bufname, ":t") -- regular file (basename)
      icon, _, is_default = MiniIcons.get("file", bufname)
      if is_default and vim.bo.filetype ~= "" then
        tabfilename = vim.bo.filetype
        icon, _ = MiniIcons.get("filetype", vim.bo.filetype)
      end
    end
    table.insert(result, icon .. " ")
    table.insert(result, tabfilename .. " ")
    if vim.fn.getbufvar(bufnr, "&modified") == 1 then
      table.insert(result, "[+] ")
    end
    table.insert(result, "%T") -- END clickable region
  end
  table.insert(result, "%#TabLineFill#%T") -- fill rest of tabline
  return table.concat(result, "")
end

vim.o.tabline = "%!v:lua.custom_tabline()"

-- }}}
