-- vim.pack {{{

vim.pack.add({
  -- Language Server (LSP)
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/aerial.nvim",
  -- Autocompletion
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("1.0.0 - 2.0.0"),
  },
  -- Tree Sitter
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  "https://github.com/tronikelis/ts-autotag.nvim",
  -- Git
  "https://github.com/junegunn/gv.vim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/sindrets/diffview.nvim",
  -- My Plugins
  "https://github.com/pappasam/nvim-repl",
  "https://github.com/pappasam/papercolor-theme-slim",
  "https://github.com/pappasam/vim-filetype-formatter",
  "https://github.com/pappasam/vim-keywordprg-commands",
  -- AI
  "https://github.com/coder/claudecode.nvim",
  -- Remainder
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/fei6409/log-highlight.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/hedengran/fga.nvim",
  "https://github.com/fladson/vim-kitty",
  "https://github.com/mikesmithgh/kitty-scrollback.nvim",
  "https://github.com/HiPhish/info.vim",
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/chrishrb/gx.nvim",
  "https://github.com/brianhuster/live-preview.nvim",
  "https://github.com/sotte/presenting.nvim",
  "https://github.com/echasnovski/mini.nvim",
})

vim.api.nvim_create_autocmd({ "PackChanged" }, {
  group = vim.api.nvim_create_augroup("TreesitterUpdated", { clear = true }),
  ---@param event {data: {kind: "install" | "update" | "delete", path: string, spec: vim.pack.Spec}}
  callback = function(event)
    if
      event.data.spec.name == "nvim-treesitter"
      and event.data.kind == "update"
    then
      vim.schedule(function()
        vim.cmd("TSUpdate")
      end)
    end
  end,
})

-- }}}
-- nvim:lsp.txt {{{

vim.lsp.handlers["window/showMessage"] = vim.lsp.handlers.notify

vim.lsp.enable({
  "autotools_ls",
  "basedpyright",
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
  "prismals",
  "r_language_server",
  "rust_analyzer",
  "shopify_theme_ls",
  "svelte",
  "taplo",
  "terraformls",
  "ts_ls",
  "vimls",
  "vue_ls",
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
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportAny = false,
          reportDeprecated = false,
          reportExplicitAny = false,
          reportImplicitStringConcatenation = false,
          reportMissingParameterType = false,
          reportMissingTypeArgument = false,
          reportMissingTypeStubs = false,
          reportUnannotatedClassAttribute = false,
          reportUninitializedInstanceVariable = false,
          reportUnknownArgumentType = false,
          reportUnknownMemberType = false,
          reportUnknownParameterType = false,
          reportUnknownVariableType = false,
          reportUnnecessaryComparison = false,
          reportUnnecessaryIsInstance = false,
          reportUnusedCallResult = false,
          reportUnusedFunction = false,
          reportUnusedParameter = false,
        },
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
vim.lsp.config("harper_ls", {
  settings = {
    ["harper-ls"] = {
      linters = {
        LongSentences = false,
        SentenceCapitalization = false,
        Spaces = false,
        SpellCheck = false,
        ToDoHyphen = false,
      },
    },
  },
})
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
vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      -- Vue support. Will need to manually update if node version updated
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.expand(
          "$HOME/.local/share/mise/installs/node/22.8.0/lib/node_modules/@vue/typescript-plugin/"
        ),
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
})
vim.lsp.config("yamlls", {
  filetypes = { "yaml" },
  settings = {
    yaml = {
      schemas = {
        kubernetes = "", -- disable built-in kubernetes support because we use specific version below
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone/all.json"] = "*.k8s.yaml",
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

-- }}}
-- nvim:diagnostic.txt {{{
vim.diagnostic.config({
  jump = {
    float = true,
  },
})
-- }}}
-- nvim:treesitter.txt {{{
-- Manually run the following for new installations -> :TSInstall all

vim.treesitter.language.register("terraform", "terraform-vars")
vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("bash", "shell")

-- }}}
-- echasnovski/mini.nvim {{{

require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
})
require("mini.ai").setup({})
require("mini.surround").setup({})
require("mini.diff").setup({
  view = {
    style = "sign",
  },
})
require("mini.icons").setup({})

MiniIcons.mock_nvim_web_devicons() -- call before nvim-tree setup

-- }}}
-- nvim-tree/nvim-tree.lua {{{
require("nvim-tree").setup({
  disable_netrw = true,
  filters = {
    dotfiles = true,
    custom = {
      "/__pycache__",
    },
    exclude = {
      "/.github",
      "/dotfiles",
      "/instance",
    },
  },
  renderer = {
    full_name = true,
  },
})
-- }}}
-- nvim-telescope/telescope.nvim {{{
require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "^node_modules/",
      "^%.git/",
      "^%.venv/",
    },
    layout_strategy = "flex",
    layout_config = {
      height = 0.9,
      width = 0.9,
    },
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
    prompt_prefix = " ",
  },
})
-- }}}
-- coder/claudecode.nvim {{{
require("claudecode").setup()
-- }}}
-- stevearc/aerial.nvim {{{
require("aerial").setup({})
-- }}}
-- Saghen/blink.cmp {{{
require("blink-cmp").setup({
  completion = {
    keyword = {
      range = "full",
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon" },
          { "source_id" },
        },
      },
    },
  },
  cmdline = {
    enabled = false,
  },
})
-- }}}
-- catgoose/nvim-colorizer.lua {{{
require("colorizer").setup({
  filetypes = {
    "css",
    "kitty",
    "markdown",
    "typescriptreact",
    "vim",
    "yaml",
  },
})
-- }}}
-- sindrets/diffview.nvim {{{
require("diffview").setup({
  enhanced_diff_hl = true,
  show_help_hints = false,
  file_panel = {
    listing_style = "tree",
    win_config = {
      width = 30,
    },
  },
  hooks = {
    diff_buf_read = function(_)
      vim.opt_local.wrap = false
    end,
  },
})
-- }}}
-- chrishrb/gx.nvim {{{
---@diagnostic disable-next-line: missing-fields
require("gx").setup({
  open_browser_app = "firefox",
  handlers = {
    cratesio = {
      name = "cratesio",
      filename = "Cargo.toml",
      handle = function(mode, line, _)
        local pkg = require("gx.helper").find(line, mode, "([^=%s]+)%s-=%s")
        if pkg then
          return "https://crates.io/crates/" .. pkg
        end
      end,
    },
    pypi = {
      name = "pypi",
      filename = "pyproject.toml",
      handle = function(mode, line, _)
        -- Match poetry dependencies (name = "version")
        local pkg = require("gx.helper").find(line, mode, "([^=%s]+)%s-=%s")
        if pkg then
          return "https://pypi.org/project/" .. pkg
        end
        -- Match builtin dependencies list format ("name>=version" or "name")
        local dep_pkg =
          require("gx.helper").find(line, mode, '"([^>=%s"]+)[^"]*"')
        if dep_pkg then
          return "https://pypi.org/project/" .. dep_pkg
        end
      end,
    },
    ruff = {
      name = "ruff",
      filetypes = { "python" },
      handle = function(mode, line, _)
        local rule =
          require("gx.helper").find(line, mode, "# noqa: ([A-Z][0-9]+)")
        if rule then
          return "https://docs.astral.sh/ruff/rules/" .. rule
        end
      end,
    },
    npmjs = {
      name = "npmjs",
      filename = "package.json",
      handle = function(mode, line, _)
        local pkg = require("gx.helper").find(line, mode, '"([^"]+)":')
        if pkg then
          return "https://www.npmjs.com/package/" .. pkg
        end
      end,
    },
  },
})
-- }}}
-- tronikelis/ts-autotag.nvim {{{
require("ts-autotag").setup({})
-- }}}
-- sotte/presenting.nvim {{{
require("presenting").setup({
  options = {
    width = 60,
  },
  separator = {
    markdown = "^##? ", -- # or ##, but not ###+
  },
  configure_slide_buffer = function(_)
    vim.cmd([[
      Fidget suppress
      setlocal buftype=nofile filetype=markdown bufhidden=wipe nomodifiable wrap conceallevel=3 concealcursor=nc
      nnoremap <buffer> q <Cmd>Presenting<CR>
      nnoremap <buffer> <C-w> <NOP>
      cnoreabbrev <buffer> q Presenting
      echo
    ]])
  end,
})
-- }}}
-- j-hui/fidget.nvim {{{
require("fidget").setup({
  progress = {
    suppress_on_insert = true,
  },
})
-- }}}
-- hedengran/fga.nvim {{{
require("fga").setup({
  install_treesitter_grammar = false,
})
-- }}}
