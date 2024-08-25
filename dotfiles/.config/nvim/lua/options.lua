--- background {{{

local function alacritty_background_setter(filepath)
  local file = io.open(filepath, "r")
  if file then
    local content = file:read("*a")
    file:close()
    if content:match("light") then
      vim.o.background = "light"
    else
      vim.o.background = "dark"
    end
  else
    -- Create an empty file if it doesn't exist
    file = io.open(filepath, "w")
    ---@diagnostic disable-next-line: need-check-nil
    file:close()
    vim.o.background = "dark"
  end
end

-- Watch the file for changes
local function alacritty_background_watcher(filepath)
  -- Set initial background
  alacritty_background_setter(filepath)
  ---@diagnostic disable-next-line: undefined-field
  local handle = vim.uv.new_fs_event()
  ---@diagnostic disable-next-line: undefined-field
  vim.uv.fs_event_start(
    handle,
    filepath,
    {},
    ---@diagnostic disable-next-line: unused-local
    vim.schedule_wrap(function(err, filename, status)
      if err then
        print("Error watching file:", err)
        return
      end
      alacritty_background_setter(filepath) -- Update background based on file content
    end)
  )
end

alacritty_background_watcher(vim.env.ALACRITTY_BACKGROUND_CACHE_FILE)

--- }}}
