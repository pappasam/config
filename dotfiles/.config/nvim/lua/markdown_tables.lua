local M = {}
local windows = {}
local pending = false
local group
local border_hl = "@punctuation.special.markdown"

local function enabled(win)
  local opts = vim.wo[win]
  if opts.conceallevel ~= 3 or opts.diff then
    return false
  end
  for mode in ("nvic"):gmatch(".") do
    if not opts.concealcursor:find(mode, 1, true) then
      return false
    end
  end
  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "markdown"
end

-- Reuse the installed inline queries, including conceal metadata, so cell
-- markup follows the same rules as the surrounding Markdown at level 3.
local function cell_units(text)
  text = vim.trim(text):gsub("\t", " ")
  local spans = {}
  local query = vim.treesitter.query.get("markdown_inline", "highlights")
  if query then
    local parser = vim.treesitter.get_string_parser(text, "markdown_inline")
    for id, node, metadata in
      query:iter_captures(parser:parse()[1]:root(), text)
    do
      local range = vim.treesitter.get_range(node, text, metadata[id])
      local name = query.captures[id]
      local conceal = metadata.conceal
      if metadata[id] and metadata[id].conceal ~= nil then
        conceal = metadata[id].conceal
      end
      if
        conceal ~= nil
        or (name:sub(1, 1) ~= "_" and name ~= "spell" and name ~= "nospell")
      then
        spans[#spans + 1] = {
          first = range[3],
          last = range[6],
          hidden = conceal ~= nil,
          hl = "@" .. name .. ".markdown_inline",
        }
      end
    end
  end
  local units, byte = {}, 0
  for i = 0, vim.fn.strchars(text, true) - 1 do
    local char = vim.fn.strcharpart(text, i, 1, true)
    local hidden, hl = false, "Normal"
    for _, span in ipairs(spans) do
      if byte >= span.first and byte < span.last then
        hidden = hidden or span.hidden
        hl = span.hl
      end
    end
    if not hidden then
      units[#units + 1] = { char, hl, vim.fn.strdisplaywidth(char) }
    end
    byte = byte + #char
  end
  return units
end

local function wrap(units, width)
  local lines, start = {}, 1
  while start <= #units do
    local finish, used, space = start, 0, nil
    while finish <= #units and used + units[finish][3] <= width do
      used = used + units[finish][3]
      if units[finish][1] == " " then
        space = finish
      end
      finish = finish + 1
    end
    local next_start = finish
    if finish <= #units and space and space > start then
      finish, next_start = space, space + 1
    end
    local line = {}
    for i = start, finish - 1 do
      line[#line + 1] = units[i]
    end
    while #line > 0 and line[#line][1] == " " do
      table.remove(line)
    end
    lines[#lines + 1] = line
    start = next_start
    while units[start] and units[start][1] == " " do
      start = start + 1
    end
  end
  return #lines > 0 and lines or { {} }
end

local function add(chunks, text, hl)
  local last = chunks[#chunks]
  if last and last[2] == hl then
    last[1] = last[1] .. text
  elseif text ~= "" then
    chunks[#chunks + 1] = { text, hl }
  end
end

local function render_table(buf, ns, node, available)
  local rows, widths, minimum, align = {}, {}, {}, {}
  local delimiter
  local first_row, first_col = node:range()
  local first_line =
    vim.api.nvim_buf_get_lines(buf, first_row, first_row + 1, false)[1]
  local prefix = first_line:sub(1, first_col)
  -- Container markers that differ between rows need their own layout.
  if prefix:find("[^%s>]") then
    return
  end
  for child in node:iter_children() do
    if child:type() == "pipe_table_delimiter_row" then
      delimiter = child:start()
      for cell in child:iter_children() do
        if cell:type() == "pipe_table_delimiter_cell" then
          local text = vim.trim(vim.treesitter.get_node_text(cell, buf))
          align[#align + 1] = text:sub(-1) == ":"
              and (text:sub(1, 1) == ":" and "center" or "right")
            or "left"
        end
      end
    elseif
      child:type() == "pipe_table_header" or child:type() == "pipe_table_row"
    then
      local row = { line = child:start(), cells = {} }
      local source =
        vim.api.nvim_buf_get_lines(buf, row.line, row.line + 1, false)[1]
      if source:sub(1, #prefix) ~= prefix then
        return
      end
      for cell in child:iter_children() do
        if cell:type() == "pipe_table_cell" then
          local units = cell_units(vim.treesitter.get_node_text(cell, buf))
          local index, width = #row.cells + 1, 0
          for _, unit in ipairs(units) do
            width = width + unit[3]
            minimum[index] = math.max(minimum[index] or 1, unit[3])
          end
          widths[index] = math.max(widths[index] or 1, width)
          row.cells[index] = units
        end
      end
      rows[#rows + 1] = row
    end
  end
  if not delimiter or #align == 0 or #widths > #align then
    return
  end
  local budget = available - vim.fn.strdisplaywidth(prefix) - 3 * #align - 1
  local total = 0
  for i = 1, #align do
    widths[i] = math.max(minimum[i] or 1, math.min(widths[i] or 1, 50))
    total = total + widths[i]
  end
  while total > budget do
    local widest
    for i, width in ipairs(widths) do
      if
        width > (minimum[i] or 1) and (not widest or width > widths[widest])
      then
        widest = i
      end
    end
    if not widest then
      return -- Too narrow to display every column without losing characters.
    end
    widths[widest], total = widths[widest] - 1, total - 1
  end
  local function border(left, middle, right)
    local pieces = {}
    for _, width in ipairs(widths) do
      pieces[#pieces + 1] = ("─"):rep(width + 2)
    end
    return {
      { prefix .. left .. table.concat(pieces, middle) .. right, border_hl },
    }
  end
  local function mark(row, chunks, extra)
    local source = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
    vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
      end_row = row,
      end_col = #source,
      end_right_gravity = true,
      conceal = "",
      priority = 200,
      virt_text = chunks,
      virt_text_pos = "overlay",
      virt_lines = extra,
      hl_mode = "replace",
    })
  end
  mark(
    delimiter,
    border("├", "┼", "┤"),
    #rows == 1 and { border("╰", "┴", "╯") } or nil
  )
  for index, row in ipairs(rows) do
    local cells, height = {}, 1
    for i, width in ipairs(widths) do
      cells[i] = wrap(row.cells[i] or {}, width)
      height = math.max(height, #cells[i])
    end
    local lines = {}
    for line = 1, height do
      local chunks = { { prefix .. "│", border_hl } }
      for i, width in ipairs(widths) do
        local units, used = cells[i][line] or {}, 0
        for _, unit in ipairs(units) do
          used = used + unit[3]
        end
        local padding = width - used
        local left = align[i] == "right" and padding
          or (align[i] == "center" and math.floor(padding / 2) or 0)
        add(chunks, (" "):rep(left + 1), "Normal")
        for _, unit in ipairs(units) do
          add(chunks, unit[1], unit[2])
        end
        add(chunks, (" "):rep(padding - left + 1), "Normal")
        add(chunks, "│", border_hl)
      end
      -- Stripe logical body rows, including all their wrapped lines.
      if index % 2 == 0 then
        for _, chunk in ipairs(chunks) do
          chunk[2] = { chunk[2], "CursorLine" }
        end
      end
      lines[#lines + 1] = chunks
    end
    if index == #rows and #rows > 1 then
      lines[#lines + 1] = border("╰", "┴", "╯")
    end
    local first = table.remove(lines, 1)
    mark(row.line, first, lines)
  end
  vim.api.nvim_buf_set_extmark(buf, ns, first_row, 0, {
    virt_lines = { border("╭", "┬", "╮") },
    virt_lines_above = true,
  })
end

local function clear(state)
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_clear_namespace(state.buf, state.ns, 0, -1)
  end
  state.buf, state.tick = nil, nil
end

function M.refresh()
  for win, state in pairs(windows) do
    if not vim.api.nvim_win_is_valid(win) or not enabled(win) then
      clear(state)
      if not vim.api.nvim_win_is_valid(win) then
        windows[win] = nil
      end
    end
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if enabled(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local width = vim.api.nvim_win_get_width(win)
        - vim.fn.getwininfo(win)[1].textoff
      local tick = vim.api.nvim_buf_get_changedtick(buf)
      local state = windows[win]
      if not state then
        state =
          { ns = vim.api.nvim_create_namespace("markdown_tables_" .. win) }
        -- Window-scoped persistent marks also let Neovim wrap at the concealed
        -- width. Ephemeral conceal marks cannot do that. Requires current 0.13.
        vim.api.nvim__ns_set(state.ns, { wins = { win } })
        windows[win] = state
      end
      if state.buf ~= buf or state.tick ~= tick or state.width ~= width then
        clear(state)
        state.buf, state.tick, state.width = buf, tick, width
        local parser = vim.treesitter.get_parser(buf, "markdown")
        local query =
          vim.treesitter.query.parse("markdown", "(pipe_table) @table")
        for _, node in query:iter_captures(parser:parse()[1]:root(), buf) do
          render_table(buf, state.ns, node, width)
        end
      end
    end
  end
end

local function schedule()
  if pending then
    return
  end
  pending = true
  vim.schedule(function()
    pending = false
    M.refresh()
  end)
end

function M.setup()
  if not group then
    group = vim.api.nvim_create_augroup("MarkdownTables", { clear = true })
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "WinEnter",
      "WinClosed",
      "WinResized",
      "VimResized",
      "TextChanged",
      "TextChangedI",
      "TextChangedP",
      "InsertLeave",
    }, { group = group, callback = schedule })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = group,
      pattern = {
        "conceallevel",
        "concealcursor",
        "diff",
        "filetype",
        "number",
        "relativenumber",
        "numberwidth",
        "signcolumn",
        "foldcolumn",
        "statuscolumn",
      },
      callback = schedule,
    })
  end
  schedule()
end

return M
