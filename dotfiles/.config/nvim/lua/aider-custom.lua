local M = {}

function M.diagnostics_full()
  local diagnostics = vim.diagnostic.get(0)
  local commentstring = vim.bo.commentstring
  if commentstring == "" then
    commentstring = "# %s"
  end
  local left_comment, right_comment = commentstring:match("(.*)%%s(.*)")
  if not left_comment then
    left_comment = "# "
    right_comment = ""
  end
  local formatted_text = {
    string.format(
      "%sAI! Please resolve the following linting error(s):%s",
      left_comment,
      right_comment
    ),
  }
  for _, d in ipairs(diagnostics) do
    local start_col = d.col
    local end_col = d.end_col and d.end_col - 1 or start_col
    local message = d.message:gsub("\n%s*", " ")
    local line = string.format(
      "|%d col %d-%d %s| %s",
      d.lnum + 2,
      start_col + 1,
      end_col + 1,
      d.severity < 2 and "error" or "warning",
      message
    )
    line = string.format(
      "%s%s%s",
      left_comment:gsub("^%s*", ""),
      line,
      right_comment
    )
    table.insert(formatted_text, line)
  end
  local result = table.concat(formatted_text, " || ")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { result })
  vim.cmd("normal! m'") -- add to jumplist
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  print(string.format("Inserted %d diagnostics below cursor", #diagnostics))
end

function M.diagnostics_cursor()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line_num = pos[1] - 1 -- Convert to 0-based line number
  local col = pos[2]
  local diagnostics = vim.diagnostic.get(0)
  local cursor_diagnostics = {}
  for _, d in ipairs(diagnostics) do
    if
      d.lnum == line_num
      and d.col <= col
      and (d.end_col or d.col + 1) > col
    then
      table.insert(cursor_diagnostics, d)
    end
  end
  local commentstring = vim.bo.commentstring
  if commentstring == "" then
    commentstring = "# %s"
  end
  local left_comment, right_comment = commentstring:match("(.*)%%s(.*)")
  if not left_comment then
    left_comment = "# "
    right_comment = ""
  end
  local formatted_text = {
    string.format(
      "%sAI! Please resolve the following linting error(s):%s",
      left_comment,
      right_comment
    ),
  }
  for _, d in ipairs(cursor_diagnostics) do
    local start_col = d.col
    local end_col = d.end_col and d.end_col - 1 or start_col
    local message = d.message:gsub("\n%s*", " ")
    local line = string.format(
      "|%d col %d-%d %s| %s",
      d.lnum + 2,
      start_col + 1,
      end_col + 1,
      d.severity < 2 and "error" or "warning",
      message
    )
    line = string.format(
      "%s%s%s",
      left_comment:gsub("^%s*", ""),
      line,
      right_comment
    )
    table.insert(formatted_text, line)
  end
  local result = table.concat(formatted_text, " || ")
  local insert_line = pos[1] - 1 -- Subtract 1 to insert above cursor
  vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { result })
  vim.cmd("normal! m'") -- add to jumplist
  vim.api.nvim_win_set_cursor(0, { insert_line + 1, 0 })
  print(
    string.format("Inserted %d diagnostics above cursor", #cursor_diagnostics)
  )
end

return M
