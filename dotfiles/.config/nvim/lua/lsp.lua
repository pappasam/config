-- Neovim LSP and diagnostics. See :help lsp and :help diagnostic

vim.lsp.handlers["window/showMessage"] = vim.lsp.handlers.notify

local function completion_source_priority(item)
  if vim.tbl_get(item, "user_data", "nvim", "lsp") then
    return 1
  elseif vim.tbl_get(item, "user_data", "config_snippet") then
    return 2
  end
  return 3
end

local function compare_completion_items(left, right)
  local left_priority = completion_source_priority(left)
  local right_priority = completion_source_priority(right)
  if left_priority ~= right_priority then
    return left_priority < right_priority
  end

  local left_score = left._fuzzy_score or 0
  local right_score = right._fuzzy_score or 0
  if left_score ~= right_score then
    return left_score > right_score
  end

  local left_lsp_item = vim.tbl_get(
    left,
    "user_data",
    "nvim",
    "lsp",
    "completion_item"
  ) or {}
  local right_lsp_item = vim.tbl_get(
    right,
    "user_data",
    "nvim",
    "lsp",
    "completion_item"
  ) or {}
  local left_label = left_lsp_item.sortText
    or left_lsp_item.label
    or left.abbr
    or left.word
    or ""
  local right_label = right_lsp_item.sortText
    or right_lsp_item.label
    or right.abbr
    or right.word
    or ""
  return left_label < right_label
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("NativeLspCompletion", { clear = true }),
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = false,
        cmp = compare_completion_items,
      })
    end
  end,
})

local completion_documentation_width = 60

local function apply_completion_documentation_style(winid)
  if
    type(winid) ~= "number"
    or winid == 0
    or not vim.api.nvim_win_is_valid(winid)
  then
    return
  end

  vim.api.nvim_win_set_config(winid, {
    border = "rounded",
    width = math.min(
      vim.api.nvim_win_get_width(winid),
      completion_documentation_width
    ),
  })
  vim.wo[winid].wrap = true
end

local function style_completion_documentation(event)
  if event.event == "CompleteChanged" then
    local completed_item = vim.v.event.completed_item or {}
    local selected = vim.fn.complete_info({ "selected" }).selected
    if
      selected
      and selected >= 0
      and type(completed_item.info) == "string"
      and completed_item.info ~= ""
    then
      local window = vim.api.nvim__complete_set(selected, {
        info = completed_item.info,
      })
      apply_completion_documentation_style(window.winid)
    end
  end

  vim.schedule(function()
    local info = vim.fn.complete_info({ "preview_winid" })
    apply_completion_documentation_style(info.preview_winid)
  end)
end

vim.api.nvim_create_autocmd({ "CompleteChanged", "WinNew" }, {
  group = vim.api.nvim_create_augroup(
    "CompletionDocumentationStyle",
    { clear = true }
  ),
  callback = style_completion_documentation,
})

vim.lsp.enable({
  "actionsls",
  "autotools_ls",
  "bashls",
  "clangd", -- needs project-level compile-commands.json
  "cssls",
  "dockerls",
  "gopls",
  "graphql",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "mdx_analyzer",
  "postgres_lsp",
  "r_language_server",
  "rust_analyzer",
  "shopify_theme_ls",
  "svelte",
  "tailwindcss",
  "taplo",
  "terraformls",
  "tsc",
  "ty",
  "vimls",
  "yamlls",
})

vim.lsp.config("*", {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false, -- https://github.com/neovim/neovim/issues/23291
      },
    },
  },
})

-- Error: libbfd-2.38-system.so: cannot open shared object file: No such file or directory
-- Solve: sudo ln -s /usr/lib/x86_64-linux-gnu/libbfd-2.42-system.so /usr/lib/x86_64-linux-gnu/libbfd-2.38-system.so
-- See: <https://github.com/StarRocks/starrocks/issues/50226#issuecomment-2321161899>
vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (
          vim.uv.fs_stat(path .. "/.luarc.json")
          or vim.uv.fs_stat(path .. "/.luarc.jsonc")
        )
      then
        return
      end
    end
    client.config.settings.Lua =
      vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          version = "LuaJIT",
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = vim
            .iter({
              (function()
                local plugins_path = vim.fn.stdpath("data")
                  .. "/site/pack/core/opt"
                local plugin_dirs = {}
                local plugins = vim.fn.glob(plugins_path .. "/*", false, true)
                for _, plugin in ipairs(plugins) do
                  local lua_dir = plugin .. "/lua"
                  if vim.fn.isdirectory(lua_dir) == 1 then
                    table.insert(plugin_dirs, lua_dir)
                  end
                  table.insert(plugin_dirs, plugin)
                end
                return plugin_dirs
              end)(),
              vim.env.VIMRUNTIME,
            })
            :flatten()
            :totable(),
        },
      })
  end,
  settings = {
    Lua = {
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config("cssls", {
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

vim.lsp.config("yamlls", {
  filetypes = { "yaml" },
  settings = {
    yaml = {
      schemas = {
        kubernetes = "", -- Disable built-in Kubernetes support because we use specific version below
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.35.0-standalone/all.json"] = "*.k8s.yaml",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/refs/heads/main/schema/compose-spec.json"] = {
          "compose.yml",
          "compose.yaml",
        },
        ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
      },
      customTags = {
        "!ENV scalar",
        "!ENV sequence",
        "!relative scalar",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji",
        "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
      },
      -- Add this to help with schema validation
      validate = true,
      -- This can help with schema conflicts
      schemaStore = {
        enable = false,
        url = "",
      },
    },
  },
})

vim.diagnostic.config({
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
  },
})
