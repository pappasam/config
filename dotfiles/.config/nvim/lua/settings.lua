-- Neovim options. See :help option-list
-- 'tabline' {{{

local function is_telescope_active()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if ft == "TelescopePrompt" then
        return true
      end
    end
  end
  return false
end

function _G.custom_tabline()
  local result = {}
  local devicons = require("nvim-web-devicons")
  for i = 1, vim.fn.tabpagenr("$") do
    local is_current_tab = i == vim.fn.tabpagenr()
    if is_current_tab then
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
    local icon
    if is_current_tab and is_telescope_active() then
      tabfilename = "Telescope"
      icon = "🔍︎"
    elseif bufname:match("^term://") then
      tabfilename = "term"
      icon = devicons.get_icon_by_filetype("terminal") .. " "
      local command = bufname:match("term://.-//[0-9]+:(.+)")
      if command then
        local first_word = command:match("([^%s]+)")
        if first_word then
          local last_part = first_word:match("([^/]+)$") or first_word
          tabfilename = last_part
        end
      end
    else
      local basename = vim.fn.fnamemodify(bufname, ":t") -- regular file (basename)
      local extension = vim.fn.fnamemodify(bufname, ":e")
      local filetype = vim.bo[bufnr].filetype
      icon = devicons.get_icon(basename, extension, { default = true }) .. " "
      if filetype == "NvimTree" then
        tabfilename = filetype
        icon = "≣ "
      elseif filetype == "aerial" then
        tabfilename = filetype
        icon = "≡ "
      elseif basename ~= "" then
        tabfilename = basename
      elseif filetype ~= "" then
        tabfilename = filetype
      else
        tabfilename = "[NO NAME]"
      end
    end
    table.insert(result, icon)
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
