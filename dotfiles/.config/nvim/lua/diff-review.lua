local M = {}

M.disable_folders = {
  ".git",
  ".pytest_cache",
  ".venv",
  "__pycache__",
  "node_modules",
}

local disable_set = {}
for _, name in ipairs(M.disable_folders) do
  disable_set[name] = true
end

local state = { active = false, allowed = {}, statuses = {} }
local ns = vim.api.nvim_create_namespace("diff_review")
local status_label = {
  A = { "[a]", "DiffAdd" },
  M = { "[m]", "DiffChange" },
}

function M.tree_custom_filter(absolute_path)
  local name = vim.fn.fnamemodify(absolute_path, ":t")
  if disable_set[name] then
    return true
  end
  if state.active then
    return not state.allowed[absolute_path]
  end
  return false
end

local function goto_first_hunk()
  vim.defer_fn(function()
    pcall(require("gitsigns").nav_hunk, "first")
  end, 200)
end

local function start(base)
  local api = require("nvim-tree.api")
  base = base
    or vim.fn.trim(
      vim.fn.system(
        "git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null"
          .. " | sed 's|refs/remotes/origin/||'"
      )
    )
  if base == "" then
    base = "main"
  end
  local merge_base = vim.fn.trim(vim.fn.system("git merge-base HEAD " .. base))
  local root = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
  local output = vim.fn.system("git diff --name-status " .. merge_base)
  local allowed = {}
  local statuses = {}
  local first_file = nil
  for line in output:gmatch("[^\n]+") do
    local status, rest = line:match("^(%a)%d*\t(.+)$")
    if status and rest and (status == "A" or status == "M") then
      local file = rest
      local abs = root .. "/" .. file
      if not first_file then
        first_file = abs
      end
      allowed[abs] = true
      statuses[abs] = status
      local dir = vim.fn.fnamemodify(abs, ":h")
      while dir ~= root and dir ~= "/" do
        allowed[dir] = true
        dir = vim.fn.fnamemodify(dir, ":h")
      end
    end
  end
  allowed[root] = true
  state.active = true
  state.allowed = allowed
  state.statuses = statuses
  require("gitsigns").change_base(base, true)
  api.tree.open()
  api.tree.resize({ absolute = 50 })
  api.tree.reload()
  api.tree.expand_all()
  if first_file then
    api.tree.find_file({ buf = first_file, focus = true })
    vim.cmd("wincmd l")
    vim.cmd("edit " .. vim.fn.fnameescape(first_file))
    vim.opt_local.foldenable = false
    goto_first_hunk()
  end
end

local function stop()
  local api = require("nvim-tree.api")
  state.active = false
  state.allowed = {}
  state.statuses = {}
  require("gitsigns").reset_base(true)
  api.tree.resize()
  api.tree.reload()
end

function M.setup()
  local api = require("nvim-tree.api")

  vim.api.nvim_create_user_command("DiffReview", function(args)
    start(args.args ~= "" and args.args or nil)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("DiffReviewClose", function()
    stop()
  end, {})

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if state.active and vim.bo.buftype == "" then
        vim.opt_local.foldenable = false
        goto_first_hunk()
      end
    end,
  })

  api.events.subscribe(api.events.Event.TreeRendered, function(payload)
    if not state.active then
      return
    end
    local bufnr = payload.bufnr
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for i, line in ipairs(lines) do
      for abs, status in pairs(state.statuses) do
        local basename = vim.fn.fnamemodify(abs, ":t")
        if line:find(basename, 1, true) then
          local label = status_label[status]
          if label then
            vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
              virt_text = { { label[1], label[2] } },
              virt_text_pos = "eol",
            })
          end
          break
        end
      end
    end
  end)
end

return M
