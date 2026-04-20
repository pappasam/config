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
  vim.o.scrollback = 100000
  vim.o.list = false
  vim.o.cursorline = false
  vim.o.cursorcolumn = false
  vim.o.virtualedit = "all"
  vim.opt.fillchars = { eob = " " }
  vim.opt.shortmess:append("AI")
end

local function set_terminal_colors(meta)
  local result = vim.system(
    { meta.kitty_path, "@", "get-colors", "--match=id:" .. meta.window_id },
    { text = true }
  ):wait()
  if result.code ~= 0 then
    return
  end
  local colors = {}
  for line in result.stdout:gmatch("[^\r\n]+") do
    local key, value = line:match("^(%S+)%s+(%S+)$")
    if key and value then
      colors[key] = value
      local i = key:match("^color(%d+)$")
      if i then
        vim.b["terminal_color_" .. i] = value
      end
    end
  end
  if colors.foreground or colors.background then
    vim.api.nvim_set_hl(0, "Normal", {
      fg = colors.foreground,
      bg = colors.background,
    })
  end
end

local function set_cursor(meta)
  vim.schedule(function()
    local x = meta.cursor_x - 1
    local y = meta.cursor_y - 1
    local scrolled_by = meta.scrolled_by
    local lines = meta.lines
    if vim.fn.has("nvim-0.12") == 1 then
      lines = lines - 1
    end
    if y < 0 then
      lines = lines + math.abs(y)
      y = 0
    end

    vim.o.scrolloff = 0
    vim.o.virtualedit = "all"
    vim.fn.cursor(vim.fn.line("$"), 1)
    if lines ~= 0 then
      vim.cmd.normal({ lines .. "k", bang = true })
    end
    if y ~= 0 then
      vim.cmd.normal({ y .. "j", bang = true })
    end
    if x ~= 0 then
      vim.cmd.normal({ x .. "l", bang = true })
    end
    if scrolled_by > 0 then
      vim.cmd.normal({
        vim.api.nvim_replace_termcodes(scrolled_by .. "<C-y>", true, false, true),
        bang = true,
      })
    end
  end)
end

local function set_keymaps(meta)
  local quit = function()
    vim.cmd("quitall!")
  end
  vim.keymap.set("n", "q", quit, { buffer = true })
  vim.keymap.set("n", "<Esc>", quit, { buffer = true })
  vim.keymap.set("v", "y", function()
    vim.cmd.normal({ '"+y', bang = true })
    quit()
  end, { buffer = true })
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

      set_options()
      set_terminal_colors(meta)

      local text_path = data_path:gsub("%.json$", ".ansi")
      local tf = io.open(text_path, "w")
      if not tf then
        return
      end
      tf:write(data.text)
      tf:close()

      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })

      vim.api.nvim_create_autocmd("TermEnter", {
        buffer = bufnr,
        callback = function()
          vim.cmd.stopinsert()
        end,
      })

      -- Use nvim_open_term to write ANSI data directly into a terminal buffer.
      -- Unlike jobstart, this has no attached process, so no "[Process exited 0]".
      local chan = vim.api.nvim_open_term(bufnr, {})
      local tf = io.open(text_path, "r")
      if tf then
        for line in tf:lines() do
          vim.api.nvim_chan_send(chan, line .. "\r\n")
        end
        tf:close()
      end
      os.remove(text_path)
      vim.api.nvim_chan_send(chan, "\027[0m")

      set_cursor(meta)
      set_keymaps(meta)
    end,
  })
end

return M
