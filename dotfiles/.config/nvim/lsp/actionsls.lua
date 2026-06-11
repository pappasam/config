local function get_github_token()
  local handle = io.popen("gh auth token 2>/dev/null")
  if not handle then
    return nil
  end
  local token = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return token ~= "" and token or nil
end

local function parse_github_remote(url)
  if not url or url == "" then
    return nil
  end

  -- SSH format: git@github.com:owner/repo.git
  local owner, repo = url:match("git@github%.com:([^/]+)/([^/%.]+)")
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  -- HTTPS format: https://github.com/owner/repo.git
  owner, repo = url:match("github%.com/([^/]+)/([^/%.]+)")
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  return nil
end

local function get_repo_info(owner, repo)
  local cmd = string.format(
    "gh repo view %s/%s --json id,owner --template '{{.id}}\t{{.owner.type}}' 2>/dev/null",
    owner,
    repo
  )
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  local id, owner_type = result:match("^(%d+)\t(.+)$")
  if id then
    return {
      id = tonumber(id),
      organizationOwned = owner_type == "Organization",
    }
  end
  return nil
end

local function get_repos_config()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    return nil
  end
  local git_root = handle:read("*a"):gsub("%s+", "")
  handle:close()

  if git_root == "" then
    return nil
  end

  handle = io.popen("git remote get-url origin 2>/dev/null")
  if not handle then
    return nil
  end
  local remote_url = handle:read("*a"):gsub("%s+", "")
  handle:close()

  local owner, name = parse_github_remote(remote_url)
  if not owner or not name then
    return nil
  end

  local info = get_repo_info(owner, name)

  return {
    {
      id = info and info.id or 0,
      owner = owner,
      name = name,
      organizationOwned = info and info.organizationOwned or false,
      workspaceUri = "file://" .. git_root,
    },
  }
end

return {
  cmd = { "actions-languageserver", "--stdio" },
  filetypes = { "yaml.ghactions" },

  -- `root_dir` ensures that the LSP does not attach to all yaml files
  root_dir = function(bufnr, on_dir)
    local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    if
      vim.endswith(parent, "/.github/workflows")
      or vim.endswith(parent, "/.forgejo/workflows")
      or vim.endswith(parent, "/.gitea/workflows")
    then
      on_dir(parent)
    end
  end,

  init_options = {},
  before_init = function(params, _)
    -- Optional: provide a GitHub token and repo context for added functionality
    -- (e.g., repository-specific completions). Do this only when the server
    -- actually starts, since these shell out to git/gh synchronously.
    params.initializationOptions = {
      sessionToken = get_github_token() or vim.NIL,
      repos = get_repos_config() or vim.NIL,
    }
  end,

  -- allow the lsp to register capabilities on demand
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },

  -- given a file:// protocol path as built using the workspaceUri above,
  -- resolve path to disk path and provide filecontents when lsp requests this
  -- action https://github.com/actions/languageservices/blob/main/languageserver/src/request.ts#L2
  -- taken from https://github.com/neovim/nvim-lspconfig/blob/75e49cfa588a89ca667d767c0afef3ceac205faa/lsp/gh_actions_ls.lua#L33-L48
  handlers = {
    ["actions/readFile"] = function(_, result)
      if type(result.path) ~= "string" then
        return nil, nil
      end
      local file_path = vim.uri_to_fname(result.path)
      if vim.fn.filereadable(file_path) == 1 then
        local f = assert(io.open(file_path, "r"))
        local text = f:read("*a")
        f:close()

        return text, nil
      end
      return nil, nil
    end,
  },
}
