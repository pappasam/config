-- Neovim LSP and diagnostics. See :help lsp and :help diagnostic

vim.lsp.handlers["window/showMessage"] = vim.lsp.handlers.notify

vim.lsp.enable({
  "autotools_ls",
  "bashls",
  "clangd", -- needs project-level compile-commands.json
  "cssls",
  "dockerls",
  "gh_actions_ls",
  "gopls",
  "graphql",
  "harper_ls",
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
  "taplo",
  "terraformls",
  "tsgo",
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

vim.lsp.config("gh_actions_ls", {
  filetypes = { "yaml.github" },
  init_options = {
    -- Requires the `repo` and `workflow` scopes
    sessionToken = os.getenv("GITHUB_ACTIONS_LS_TOKEN"),
  },
})

-- https://writewithharper.com/docs/rules
vim.lsp.config("harper_ls", {
  filetypes = {
    "markdown",
  },
  settings = {
    ["harper-ls"] = {
      markdown = {
        IgnoreLinkTitle = true,
      },
      linters = {
        LongSentences = false,
        RoadMap = false,
        SentenceCapitalization = false,
        Spaces = false,
        SpellCheck = false,
        SplitWords = false,
        ToDoHyphen = false,
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
