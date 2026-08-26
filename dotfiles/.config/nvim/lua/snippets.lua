local M = {}

local snippet_cache = {}

local function snippet_path(filetype)
  return vim.fs.joinpath(
    vim.fn.stdpath("config"),
    "snippets",
    filetype .. ".json"
  )
end

local function load_snippets(filetype)
  local path = snippet_path(filetype)
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return {}
  end

  local modified = stat.mtime.sec .. ":" .. stat.mtime.nsec
  local cached = snippet_cache[path]
  if cached and cached.modified == modified then
    return cached.snippets
  end

  local ok, decoded = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok then
    vim.notify(
      "Failed to load snippets from " .. path .. ": " .. decoded,
      vim.log.levels.ERROR
    )
    return {}
  end

  local snippets = {}
  for name, snippet in pairs(decoded) do
    local prefixes = type(snippet.prefix) == "table" and snippet.prefix
      or { snippet.prefix }
    local body = type(snippet.body) == "table"
        and table.concat(snippet.body, "\n")
      or snippet.body
    if type(body) == "string" then
      for _, prefix in ipairs(prefixes) do
        if type(prefix) == "string" then
          table.insert(snippets, {
            prefix = prefix,
            body = body,
            description = snippet.description,
            name = name,
          })
        end
      end
    end
  end

  table.sort(snippets, function(left, right)
    return left.prefix < right.prefix
  end)
  snippet_cache[path] = {
    modified = modified,
    snippets = snippets,
  }
  return snippets
end

function M.complete(findstart, base)
  if findstart == 1 then
    local line = vim.api.nvim_get_current_line()
    local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
    return vim.fn.match(line:sub(1, cursor_column), "\\k*$")
  end

  local snippets = load_snippets(vim.bo.filetype)
  if base ~= "" then
    snippets = vim.fn.matchfuzzy(snippets, base, { key = "prefix" })
  end

  local items = {}
  for _, snippet in ipairs(snippets) do
    table.insert(items, {
      word = snippet.prefix,
      abbr = snippet.prefix,
      kind = "Snippet",
      menu = "[Snippet]",
      info = snippet.description or snippet.name,
      dup = 1,
      user_data = {
        config_snippet = true,
        body = snippet.body,
      },
    })
  end
  return items
end

local function expand_completed_snippet()
  if vim.v.event.reason ~= "accept" then
    return
  end

  local item = vim.v.completed_item
  local data = item.user_data
  if type(data) ~= "table" or not data.config_snippet then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local end_column = cursor[2]
  local start_column = end_column - #item.word
  if start_column < 0 then
    return
  end

  vim.api.nvim_buf_set_text(0, row, start_column, row, end_column, {})
  vim.snippet.expand(data.body)
end

function M.setup()
  vim.o.completefunc = M.complete
  vim.api.nvim_create_autocmd("CompleteDone", {
    group = vim.api.nvim_create_augroup("ConfigSnippets", { clear = true }),
    callback = expand_completed_snippet,
  })
end

return M
