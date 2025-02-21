function CopyDiagnostics()
  local diagnostics = vim.diagnostic.get(0)
  local bufname = vim.fn.bufname()
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
      "%sAI! Please resolve the following linting errors:%s",
      left_comment,
      right_comment
    ),
    string.format("%s---%s", left_comment, right_comment),
  }
  for _, d in ipairs(diagnostics) do
    local start_col = d.col
    local end_col = d.end_col and d.end_col - 1 or start_col
    local message = d.message:gsub("\n%s*", " ")
    local line = string.format(
      "%s|%d col %d-%d %s| %s",
      bufname,
      d.lnum + 1,
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
  local result = table.concat(formatted_text, "\n")
  vim.fn.setreg("+", result)
  vim.fn.setreg('"', result)
  print(string.format("Copied %d diagnostics to clipboard", #diagnostics))
end
