local xxd_cursor_match = nil

local function highlight()
  -- Clear existing highlight
  if xxd_cursor_match and xxd_cursor_match ~= -1 then
    vim.fn.matchdelete(xxd_cursor_match)
    xxd_cursor_match = nil
  end

  -- Check if current position has syntax highlighting
  if
    vim.fn.synIDattr(
      vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1),
      "name"
    ) ~= ""
  then
    return
  end

  -- Calculate position
  local c = vim.fn.col(".") - 10
  if c % 5 == 0 then
    return
  end

  c = math.floor(c / 5) * 2 + (c % 5 > 2 and 1 or 0)

  -- Add new highlight
  xxd_cursor_match = vim.fn.matchadd(
    "XXDCursor",
    "\\%" .. (c + 52) .. "c\\%" .. vim.fn.line(".") .. "l"
  )
end

-- Create autocommand group
local xxd_group = vim.api.nvim_create_augroup("xxd", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
  group = xxd_group,
  buffer = 0, -- current buffer only
  callback = highlight,
})

-- Set highlight link
vim.api.nvim_set_hl(0, "XXDCursor", { link = "WildMenu" })
