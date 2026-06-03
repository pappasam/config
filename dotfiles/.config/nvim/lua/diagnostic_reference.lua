local M = {}

function M.lines(firstline, lastline)
  local diagnostics = vim.tbl_filter(function(diagnostic)
    local line = diagnostic.lnum + 1
    return line >= firstline and line <= lastline
  end, vim.diagnostic.get(0))

  table.sort(diagnostics, function(left, right)
    if left.lnum == right.lnum then
      return left.col < right.col
    end
    return left.lnum < right.lnum
  end)

  return vim.tbl_map(function(diagnostic)
    local severity = vim.diagnostic.severity[diagnostic.severity]
      or tostring(diagnostic.severity)
    local message = diagnostic.message:gsub("%s+", " ")
    return string.format(
      "%d:%d %s %s",
      diagnostic.lnum + 1,
      diagnostic.col + 1,
      severity,
      message
    )
  end, diagnostics)
end

return M
