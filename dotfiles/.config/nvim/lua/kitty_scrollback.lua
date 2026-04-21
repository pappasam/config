local M = {}

local function set_options()
  vim.o.termguicolors = true
  vim.o.number = false
  vim.o.relativenumber = false
  vim.o.signcolumn = "no"
  vim.o.laststatus = 0
  vim.o.cmdheight = 0
  vim.o.ruler = false
  vim.o.showmode = false
  vim.o.showtabline = 0
  vim.o.scrolloff = 0
  vim.o.mouse = "a"
  vim.o.list = false
  vim.o.cursorline = false
  vim.o.cursorcolumn = false
  vim.o.virtualedit = "all"
  vim.o.wrap = true
  vim.opt.fillchars = { eob = " " }
  vim.opt.shortmess:append("AI")
end

local function set_highlights(colors)
  if colors.foreground or colors.background then
    vim.api.nvim_set_hl(0, "Normal", {
      fg = colors.foreground,
      bg = colors.background,
    })
  end
end

local function build_palette(colors)
  local palette = {}
  for i = 0, 255 do
    if colors["color" .. i] then
      palette[i] = colors["color" .. i]
    end
  end

  local basic = {
    [0] = "#000000",
    "#800000",
    "#008000",
    "#808000",
    "#000080",
    "#800080",
    "#008080",
    "#c0c0c0",
    "#808080",
    "#ff0000",
    "#00ff00",
    "#ffff00",
    "#0000ff",
    "#ff00ff",
    "#00ffff",
    "#ffffff",
  }

  return function(n)
    if palette[n] then
      return palette[n]
    end
    if n < 16 then
      return basic[n]
    end
    if n < 232 then
      local idx = n - 16
      local b = idx % 6
      idx = (idx - b) / 6
      local g = idx % 6
      local r = (idx - g) / 6
      local function v(c)
        return c == 0 and 0 or 55 + 40 * c
      end
      return string.format("#%02x%02x%02x", v(r), v(g), v(b))
    end
    local gray = 8 + 10 * (n - 232)
    return string.format("#%02x%02x%02x", gray, gray, gray)
  end
end

local function make_hl_key(
  fg,
  bg,
  bold,
  italic,
  underline,
  reverse,
  strikethrough
)
  return (fg or "")
    .. ":"
    .. (bg or "")
    .. ":"
    .. (bold and "b" or "")
    .. (italic and "i" or "")
    .. (underline and "u" or "")
    .. (reverse and "r" or "")
    .. (strikethrough and "s" or "")
end

local function skip_escape(line, pos, line_len)
  local next_byte = line:byte(pos + 1)
  if next_byte == 93 then -- ']' OSC: skip to BEL or ST
    local bel = line:find("\007", pos + 2, true)
    local st = line:find("\027\\", pos + 2, true)
    if bel and st then
      return bel < st and bel + 1 or st + 2
    end
    return bel and bel + 1 or st and st + 2 or line_len + 1
  elseif next_byte == 91 then -- '[' non-SGR CSI: skip to terminator
    local seq_end = line:find("[A-Za-z]", pos + 2)
    return seq_end and seq_end + 1 or pos + 1
  end
  return pos + 2
end

local function parse_ansi_lines(text, color_for)
  local plain_lines = {}
  local line_extmarks = {}

  local fg, bg = nil, nil
  local bold, italic, underline, reverse, strikethrough =
    false, false, false, false, false

  for raw_line in (text .. "\n"):gmatch("([^\n]*)\n") do
    local plain = {}
    local extmarks = {}
    local col = 0
    local span_start = 0
    local span_has_style = fg ~= nil
      or bg ~= nil
      or bold
      or italic
      or underline
      or reverse
      or strikethrough
    local span_fg, span_bg = fg, bg
    local span_bold, span_italic, span_underline = bold, italic, underline
    local span_reverse, span_strikethrough = reverse, strikethrough

    local pos = 1
    local line_len = #raw_line
    while pos <= line_len do
      local esc_pos = raw_line:find("\027", pos, true)
      if esc_pos and esc_pos == pos then
        local seq_end
        if raw_line:byte(pos + 1) == 91 then -- '[' CSI
          seq_end = raw_line:find("[A-Za-z]", pos + 2)
        end
        if seq_end and raw_line:byte(seq_end) == 109 then -- SGR 'm'
          if col > span_start and span_has_style then
            table.insert(extmarks, {
              span_start,
              col,
              span_fg,
              span_bg,
              span_bold,
              span_italic,
              span_underline,
              span_reverse,
              span_strikethrough,
            })
          end

          local param_str = raw_line:sub(pos + 2, seq_end - 1)
          local i_param = 1
          local params = {}
          for n in param_str:gmatch("([^;]+)") do
            params[i_param] = tonumber(n) or 0
            i_param = i_param + 1
          end
          if i_param == 1 then
            params[1] = 0
            i_param = 2
          end

          local i = 1
          local count = i_param - 1
          while i <= count do
            local p = params[i]
            if p == 0 then
              fg, bg = nil, nil
              bold, italic, underline, reverse, strikethrough =
                false, false, false, false, false
            elseif p == 1 then
              bold = true
            elseif p == 3 then
              italic = true
            elseif p == 4 then
              underline = true
            elseif p == 7 then
              reverse = true
            elseif p == 9 then
              strikethrough = true
            elseif p == 22 then
              bold = false
            elseif p == 23 then
              italic = false
            elseif p == 24 then
              underline = false
            elseif p == 27 then
              reverse = false
            elseif p == 29 then
              strikethrough = false
            elseif p >= 30 and p <= 37 then
              fg = color_for(p - 30)
            elseif p == 38 then
              if params[i + 1] == 5 and params[i + 2] then
                fg = color_for(params[i + 2])
                i = i + 2
              elseif params[i + 1] == 2 and params[i + 4] then
                fg = string.format(
                  "#%02x%02x%02x",
                  params[i + 2],
                  params[i + 3],
                  params[i + 4]
                )
                i = i + 4
              end
            elseif p == 39 then
              fg = nil
            elseif p >= 40 and p <= 47 then
              bg = color_for(p - 40)
            elseif p == 48 then
              if params[i + 1] == 5 and params[i + 2] then
                bg = color_for(params[i + 2])
                i = i + 2
              elseif params[i + 1] == 2 and params[i + 4] then
                bg = string.format(
                  "#%02x%02x%02x",
                  params[i + 2],
                  params[i + 3],
                  params[i + 4]
                )
                i = i + 4
              end
            elseif p == 49 then
              bg = nil
            elseif p >= 90 and p <= 97 then
              fg = color_for(p - 90 + 8)
            elseif p >= 100 and p <= 107 then
              bg = color_for(p - 100 + 8)
            end
            i = i + 1
          end

          span_start = col
          span_has_style = fg ~= nil
            or bg ~= nil
            or bold
            or italic
            or underline
            or reverse
            or strikethrough
          span_fg, span_bg = fg, bg
          span_bold, span_italic, span_underline = bold, italic, underline
          span_reverse, span_strikethrough = reverse, strikethrough
          pos = seq_end + 1
        else
          pos = skip_escape(raw_line, pos, line_len)
        end
      else
        local chunk_end = esc_pos and esc_pos - 1 or line_len
        local chunk = raw_line:sub(pos, chunk_end)
        table.insert(plain, chunk)
        col = col + #chunk
        pos = chunk_end + 1
      end
    end

    if col > span_start and span_has_style then
      table.insert(extmarks, {
        span_start,
        col,
        span_fg,
        span_bg,
        span_bold,
        span_italic,
        span_underline,
        span_reverse,
        span_strikethrough,
      })
    end

    table.insert(plain_lines, table.concat(plain))
    table.insert(line_extmarks, extmarks)
  end

  return plain_lines, line_extmarks
end

local function setup_lazy_highlights(bufnr, line_extmarks)
  local ns = vim.api.nvim_create_namespace("kitty_scrollback")
  local hl_cache = {}
  local hl_idx = 0
  local hl_min = math.huge
  local hl_max = -1
  local total = #line_extmarks
  local margin = 200

  local function highlight_range(from, to)
    from = math.max(1, from)
    to = math.min(total, to)
    if from >= hl_min and to <= hl_max then
      return
    end
    local start = from < hl_min and from or hl_max + 1
    local stop = to > hl_max and to or hl_min - 1
    for lnum = start, stop do
      local extmarks = line_extmarks[lnum]
      if extmarks then
        for _, em in ipairs(extmarks) do
          local start_col, end_col = em[1], em[2]
          local em_fg, em_bg = em[3], em[4]
          local em_bold, em_italic, em_underline = em[5], em[6], em[7]
          local em_reverse, em_strikethrough = em[8], em[9]
          local key = make_hl_key(
            em_fg,
            em_bg,
            em_bold,
            em_italic,
            em_underline,
            em_reverse,
            em_strikethrough
          )
          if not hl_cache[key] then
            hl_idx = hl_idx + 1
            local group = "KsbHl" .. hl_idx
            vim.api.nvim_set_hl(0, group, {
              fg = em_reverse and em_bg or em_fg,
              bg = em_reverse and em_fg or em_bg,
              bold = em_bold,
              italic = em_italic,
              underline = em_underline,
              strikethrough = em_strikethrough,
            })
            hl_cache[key] = group
          end
          vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, start_col, {
            end_col = end_col,
            hl_group = hl_cache[key],
          })
        end
      end
    end
    hl_min = math.min(hl_min, from)
    hl_max = math.max(hl_max, to)
  end

  local function highlight_visible()
    local top = vim.fn.line("w0")
    local bot = vim.fn.line("w$")
    highlight_range(top - margin, bot + margin)
  end

  return highlight_visible
end

local function set_cursor(meta)
  vim.schedule(function()
    local line = meta.cursor_buf_line or vim.fn.line("$")
    local col = (meta.cursor_buf_col or 0) + 1
    vim.fn.cursor(line, col)
    vim.cmd("normal! zb")
  end)
end

local function set_keymaps(_)
  local quit = function()
    vim.cmd("quitall!")
  end
  vim.keymap.set("n", "q", quit, { buffer = true })
  vim.keymap.set("n", "<Esc>", quit, { buffer = true })
  vim.keymap.set("v", "y", function()
    vim.cmd.normal({ '"+y', bang = true })
    local text = vim.fn.getreg("+")
    vim.fn.setreg("+", text:gsub("\n$", ""))
    quit()
  end, { buffer = true })
  vim.keymap.set({ "n", "x" }, "k", function()
    return vim.v.count == 0 and "gk" or "k"
  end, { buffer = true, expr = true })
  vim.keymap.set({ "n", "x" }, "K", function()
    return vim.v.count == 0 and "gk" or "k"
  end, { buffer = true, expr = true })
  vim.keymap.set({ "n", "x" }, "j", function()
    return vim.v.count == 0 and "gj" or "j"
  end, { buffer = true, expr = true })
  vim.keymap.set({ "n", "x" }, "J", function()
    return vim.v.count == 0 and "gj" or "j"
  end, { buffer = true, expr = true })
end

function M.launch(data_path)
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("KittyScrollback", { clear = true }),
    once = true,
    callback = function()
      local f = io.open(data_path, "r")
      if not f then
        return
      end
      local raw = f:read("*a")
      f:close()
      os.remove(data_path)

      local data = vim.fn.json_decode(raw)
      local meta = data.metadata

      local tf = io.open(data.text_path, "r")
      if not tf then
        return
      end
      local text = tf:read("*a")
      tf:close()
      os.remove(data.text_path)

      set_options()
      local colors = meta.colors or {}
      set_highlights(colors)

      local color_for = build_palette(colors)
      local plain_lines, line_extmarks = parse_ansi_lines(text, color_for)

      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, plain_lines)

      local highlight_visible = setup_lazy_highlights(bufnr, line_extmarks)
      vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

      set_cursor(meta)
      highlight_visible()
      local group =
        vim.api.nvim_create_augroup("KittyScrollbackHL", { clear = true })
      vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved" }, {
        group = group,
        buffer = bufnr,
        callback = highlight_visible,
      })
      set_keymaps(meta)
    end,
  })
end

return M
