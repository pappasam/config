-- Neovim options. See :help option-list
-- 'tabline' {{{

function _G.custom_tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    -- Select the highlighting
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end
    -- Set the tab number
    s = s .. " " .. i .. " "
    -- Get the window number
    local winnr = vim.fn.tabpagewinnr(i)
    -- Get the buffer list for this tab
    local buflist = vim.fn.tabpagebuflist(i)
    -- Get the buffer number of the active buffer in this tab
    local bufnr = buflist[winnr]
    local filename = vim.fn.bufname(bufnr)
    -- Format the filename
    if filename == "" then
      filename = "[No Name]"
    else
      -- Check if this is a terminal buffer
      if filename:match("^term://") then
        -- Extract the actual command from the terminal buffer name
        -- Pattern matches after the process ID section to get just the command
        local command = filename:match("term://.-//[0-9]+:(.+)")
        if command then
          -- Extract just the first word of the command
          local first_word = command:match("([^%s]+)")
          if first_word then
            filename = "[" .. first_word .. "]"
          else
            filename = "[term]"
          end
        else
          filename = "[term]"
        end
      else
        -- Regular file - just show the basename
        filename = vim.fn.fnamemodify(filename, ":t")
      end
    end
    s = s .. filename .. " "
    -- Add modified indicator
    if vim.fn.getbufvar(bufnr, "&modified") == 1 then
      s = s .. "[+] "
    end
  end
  -- Fill the rest of the tabline
  s = s .. "%#TabLineFill#%T"
  return s
end

-- Set the tabline
vim.o.tabline = "%!v:lua.custom_tabline()"

-- }}}
