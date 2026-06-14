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

local state = { active = false, allowed = {}, statuses = {}, stats = {} }
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
    if pcall(require("gitsigns").nav_hunk, "first") then
      vim.defer_fn(function()
        vim.cmd("normal! z.")
      end, 50)
    end
  end, 200)
end

local function git_output(args)
  local command = { "git" }
  vim.list_extend(command, args)
  local result = vim.system(command, { text = true }):wait()
  if result.code ~= 0 then
    return ""
  end
  return vim.trim(result.stdout or "")
end

local function command_output(command)
  local result = vim.system(command, { text = true }):wait()
  if result.code ~= 0 then
    return ""
  end
  return vim.trim(result.stdout or "")
end

local function git_success(args)
  local command = { "git" }
  vim.list_extend(command, args)
  return vim.system(command):wait().code == 0
end

local function git_ref_exists(ref)
  return git_output({ "rev-parse", "--verify", "--quiet", ref .. "^{commit}" })
    ~= ""
end

local function merged_base_parent(base)
  local base_name = vim.fn.fnamemodify(base, ":t")
  local output = git_output({
    "log",
    "--first-parent",
    "--merges",
    "--pretty=%H%x09%P%x09%s",
    base .. "..HEAD",
  })

  for line in output:gmatch("[^\n]+") do
    local parents, subject = line:match("^[^\t]+\t([^\t]+)\t(.+)$")
    local first_parent, second_parent =
      (parents or ""):match("^(%x+)%s+(%x+)")
    if
      second_parent
      and subject:find(base_name, 1, true)
      and git_success({ "merge-base", "--is-ancestor", base, second_parent })
      and git_ref_exists(second_parent)
      and first_parent
    then
      return second_parent
    end
  end

  return ""
end

local function comparison_base_for(base)
  local comparison_base = merged_base_parent(base)
  if comparison_base ~= "" then
    return comparison_base
  end
  return git_output({ "merge-base", "HEAD", base })
end

local function default_base()
  local symbolic_ref =
    git_output({ "symbolic-ref", "refs/remotes/origin/HEAD" })
  local base = symbolic_ref:match("^refs/remotes/origin/(.+)$")
  if base and git_ref_exists("origin/" .. base) then
    return "origin/" .. base
  end

  for _, ref in ipairs({
    "upstream/master",
    "upstream/main",
    "origin/master",
    "origin/main",
    "master",
    "main",
  }) do
    if git_ref_exists(ref) then
      return ref
    end
  end

  return ""
end

local function pr_base()
  if vim.fn.executable("gh") ~= 1 then
    return nil
  end

  local output = command_output({
    "gh",
    "pr",
    "view",
    "--json",
    "baseRefName,baseRefOid",
    "--jq",
    "[.baseRefName, .baseRefOid] | @tsv",
  })
  local base_name, base_oid = output:match("^([^\t]+)\t([^\t]+)$")
  if not base_name or not base_oid or base_oid == "" then
    return nil
  end

  local candidates = {
    "upstream/" .. base_name,
    "origin/" .. base_name,
    base_name,
  }
  for _, ref in ipairs(candidates) do
    if git_ref_exists(ref) and git_ref_exists(base_oid) then
      return { ref = ref, comparison_base = base_oid }
    end
  end

  if git_ref_exists(base_oid) then
    return { ref = base_oid, comparison_base = base_oid }
  end

  return nil
end

local function review_base(base)
  if base and base ~= "" then
    if not git_ref_exists(base) then
      vim.notify("DiffReview: invalid base " .. base, vim.log.levels.ERROR)
      return nil
    end

    return {
      ref = base,
      comparison_base = comparison_base_for(base),
    }
  end

  local pr = pr_base()
  if pr then
    return pr
  end

  base = default_base()
  if base == "" then
    vim.notify("DiffReview: could not find a base branch", vim.log.levels.ERROR)
    return nil
  end

  return {
    ref = base,
    comparison_base = comparison_base_for(base),
  }
end

local function allow_file(root, allowed, statuses, stats, file, status, stat)
  local abs = root .. "/" .. file
  allowed[abs] = true
  statuses[abs] = status
  stats[abs] = stat
  local dir = vim.fn.fnamemodify(abs, ":h")
  while dir ~= root and dir ~= "/" do
    allowed[dir] = true
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return abs
end

local function start(base)
  local api = require("nvim-tree.api")
  local base_info = review_base(base)
  if not base_info or base_info.comparison_base == "" then
    vim.notify("DiffReview: could not resolve a comparison base", vim.log.levels.ERROR)
    return
  end
  local root = git_output({ "rev-parse", "--show-toplevel" })
  local output = git_output({ "diff", "--name-status", base_info.comparison_base })
  local stat_output = git_output({ "diff", "--numstat", base_info.comparison_base })
  local file_stats = {}
  for line in stat_output:gmatch("[^\n]+") do
    local added, removed, file = line:match("^([^\t]+)\t([^\t]+)\t(.+)$")
    if file then
      if added == "-" or removed == "-" then
        file_stats[file] = "bin"
      else
        file_stats[file] = "+" .. added .. " -" .. removed
      end
    end
  end
  local allowed = {}
  local statuses = {}
  local stats = {}
  local first_file = nil
  for line in output:gmatch("[^\n]+") do
    local status, rest = line:match("^(%a)%d*\t(.+)$")
    if status and rest and (status == "A" or status == "M") then
      local file = rest
      local abs = allow_file(
        root,
        allowed,
        statuses,
        stats,
        file,
        status,
        file_stats[file]
      )
      if not first_file then
        first_file = abs
      end
    end
  end
  local untracked_output =
    git_output({ "ls-files", "--others", "--exclude-standard" })
  for file in untracked_output:gmatch("[^\n]+") do
    local abs = allow_file(root, allowed, statuses, stats, file, "A", "new")
    if not first_file then
      first_file = abs
    end
  end
  allowed[root] = true
  state.active = true
  state.allowed = allowed
  state.statuses = statuses
  state.stats = stats
  require("gitsigns").change_base(base_info.comparison_base, true)
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
  state.stats = {}
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
            local stat = state.stats[abs]
            local text = label[1]
            if stat then
              text = text .. " " .. stat
            end
            vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
              virt_text = { { text, label[2] } },
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
