-- Packages {{{

require("packager").setup(function(p)
  -- Language Server (LSP)
  p.add("https://github.com/neovim/nvim-lspconfig")
  p.add("https://github.com/stevearc/aerial.nvim")
  -- Autocompletion
  p.add(
    "https://github.com/Saghen/blink.cmp",
    { ["do"] = "cargo build --release" }
  )
  -- Tree Sitter
  p.add("https://github.com/nvim-treesitter/nvim-treesitter")
  p.add("https://github.com/tronikelis/ts-autotag.nvim")
  -- Git
  p.add("https://github.com/junegunn/gv.vim")
  p.add("https://github.com/lewis6991/gitsigns.nvim")
  p.add("https://github.com/tpope/vim-fugitive")
  p.add("https://github.com/sindrets/diffview.nvim")
  -- My Plugins
  p.add("https://github.com/pappasam/nvim-repl")
  p.add("https://github.com/pappasam/papercolor-theme-slim")
  p.add("https://github.com/pappasam/vim-filetype-formatter")
  p.add("https://github.com/pappasam/vim-keywordprg-commands")
  -- Remainder
  p.add("https://github.com/j-hui/fidget.nvim.git")
  p.add("https://github.com/folke/snacks.nvim")
  p.add("https://github.com/nvim-tree/nvim-web-devicons")
  p.add("https://github.com/fladson/vim-kitty")
  p.add("https://github.com/mikesmithgh/kitty-scrollback.nvim")
  p.add("https://github.com/HiPhish/info.vim")
  p.add("https://github.com/catgoose/nvim-colorizer.lua")
  p.add("https://github.com/chrishrb/gx.nvim")
  p.add("https://github.com/fidian/hexmode")
  p.add(
    "https://github.com/iamcco/markdown-preview.nvim",
    { ["do"] = "cd app & yarn install" }
  )
  p.add("https://github.com/machakann/vim-sandwich")
  p.add("https://github.com/sotte/presenting.nvim.git")
  p.add("https://github.com/windwp/nvim-autopairs")
end, {
  window_cmd = "edit",
})

-- }}}
-- Language Servers: https://github.com/neovim/nvim-lspconfig {{{
-- :help lsp.txt
-- :help diagnostic.txt

local language_servers = {
  autotools_ls = {},
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          diagnosticSeverityOverrides = {
            reportAny = "none",
            reportExplicitAny = "none",
            reportUnannotatedClassAttribute = "none",
            reportUninitializedInstanceVariable = "none",
            reportUnnecessaryIsInstance = "none",
            reportUnusedCallResult = "none",
          },
        },
      },
    },
  },
  bashls = {},
  cssls = {},
  dockerls = {},
  gopls = {},
  graphql = {},
  harper_ls = {
    settings = {
      ["harper-ls"] = {
        linters = {
          SentenceCapitalization = false,
          SpellCheck = false,
        },
      },
    },
  },
  html = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {
            "vim",
            "require",
          },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  marksman = {},
  mdx_analyzer = {},
  nginx_language_server = {},
  prismals = {},
  r_language_server = {},
  rust_analyzer = {},
  shopify_theme_ls = {},
  svelte = {},
  taplo = {},
  terraformls = {},
  ts_ls = {},
  vimls = {},
  yamlls = {
    filetypes = { "yaml" },
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/kubernetes/**",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/refs/heads/main/schema/compose-spec.json"] = "/*docker-compose.yml",
          ["https://raw.githubusercontent.com/threadheap/serverless-ide-vscode/master/packages/serverless-framework-schema/schema.json"] = "/*serverless.yml",
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/3.0.3/schemas/v3.0/schema.json"] = {
            "/*open-api*.yml",
            "/*open-api*.yaml",
          },
        },
        customTags = {
          "!ENV scalar",
          "!ENV sequence",
          "!relative scalar",
          "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg",
          "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji",
          "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
        },
      },
    },
  },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false -- https://github.com/neovim/neovim/issues/23291
for server, server_config in pairs(language_servers) do
  require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
    capabilities = capabilities,
  }, server_config))
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    client.server_capabilities.semanticTokensProvider = nil -- disable semantic tokens
  end,
})

-- Custom LSP
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml.githubactions",
  callback = function(args)
    vim.lsp.start({
      name = "github-actions-languageserver",
      cmd = { "github-actions-languageserver", "--stdio" },
      root_dir = vim.fs.root(args.buf, { ".github", ".git" }),
      capabilities = capabilities,
      init_options = {
        -- Requires the `repo` and `workflow` scopes
        sessionToken = os.getenv("GITHUB_ACTIONS_LS_TOKEN"),
      },
    })
  end,
})

-- Diagnostic configuration
vim.diagnostic.config({
  jump = {
    float = true,
  },
})

-- }}}
-- Treesitter: https://github.com/nvim-treesitter/nvim-treesitter {{{
-- :help treesitter.txt

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      if lang == "javascript" then
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end
      return vim.api.nvim_buf_line_count(bufnr) > 50000
    end,
  },
  indent = {
    enable = true,
    ---@diagnostic disable-next-line: unused-local
    disable = function(lang, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  },
  ensure_installed = {
    "bash",
    "bibtex",
    "c",
    "c_sharp",
    "comment",
    "cpp",
    "css",
    "csv",
    "cuda",
    "diff",
    "dot",
    "dockerfile",
    "fortran",
    "gdscript",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "graphql",
    "haskell",
    "haskell_persistent",
    "hcl",
    "html",
    "htmldjango",
    "http",
    "ini",
    "java",
    "javascript",
    "jinja",
    "jinja_inline",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "julia",
    "kotlin",
    "latex",
    "ledger",
    "liquid",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "nginx",
    "ocaml",
    "perl",
    "php",
    "prisma",
    "printf",
    "properties",
    "pymanifest",
    "python",
    "query",
    "r",
    "regex",
    "requirements",
    "ron",
    "rst",
    "ruby",
    "rust",
    "scss",
    "sql",
    "svelte",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "xml",
    "yaml",
    "zathurarc",
  },
})

vim.treesitter.language.register("terraform", "terraform-vars")
vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("bash", "shell")

-- Fix broken queries
vim.treesitter.query.set(
  "dockerfile",
  "injections",
  '((comment) @injection.content (#set! injection.language "comment"))'
)

vim.api.nvim_set_hl(0, "@aicomment", { link = "Todo" })

-- }}}
require("snacks").setup({ -- https://github.com/folke/snacks.nvim {{{
  explorer = { enabled = true },
  gitbrowse = { enabled = true },
  image = { enabled = true },
  indent = {
    enabled = true,
    scope = {
      enabled = false,
    },
  },
  lazygit = {
    enabled = true,
    theme = {
      selectedLineBgColor = { bg = "CursorLine" },
    },
  },
  picker = {
    enabled = true,
    exclude = {
      "__pycache__",
    },
    include = {
      ".github",
      "/dotfiles/*",
      "instance",
    },
    sources = {
      explorer = {
        win = {
          list = {
            keys = {
              -- NOTE: pick_win triggered by <S-CR>
              ["o"] = "confirm",
              ["<c-t>"] = "tab",
              ["<c-x>"] = "edit_split",
              ["<c-v>"] = "edit_vsplit",
            },
          },
        },
      },
    },
  },
  rename = { enabled = true },
}) -- }}}
require("aerial").setup({ -- https://github.com/stevearc/aerial.nvim {{{
}) -- }}}
require("blink-cmp").setup({ -- https://github.com/Saghen/blink.cmp {{{
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
}) -- }}}
require("colorizer").setup({ -- https://github.com/catgoose/nvim-colorizer.lua {{{
  filetypes = {
    "css",
    "kitty",
    "typescriptreact",
    "vim",
    "yaml",
  },
}) -- }}}
require("diffview").setup({ -- https://github.com/sindrets/diffview.nvim {{{
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
}) -- }}}
require("gitsigns").setup({ -- https://github.com/lewis6991/gitsigns.nvim {{{
  signcolumn = false,
  numhl = true,
  linehl = false,
  word_diff = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Navigation
    map("n", "]g", function()
      if vim.wo.diff then
        return "]g"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
    map("n", "[g", function()
      if vim.wo.diff then
        return "[g"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
  end,
}) -- }}}
require("gx").setup({ -- https://github.com/chrishrb/gx.nvim {{{
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
        local pkg = require("gx.helper").find(line, mode, "([^=%s]+)%s-=%s")
        if pkg then
          return "https://pypi.org/project/" .. pkg
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
}) -- }}}
require("nvim-autopairs").setup({ -- https://github.com/windwp/nvim-autopairs {{{
  map_c_h = true,
  map_c_w = true,
  map_cr = true,
  enable_check_bracket_line = false,
}) -- }}}
require("ts-autotag").setup({ -- https://github.com/tronikelis/ts-autotag.nvim {{{
}) -- }}}
require("nvim-web-devicons").setup({ -- https://github.com/kyazdani42/nvim-web-devicons {{{
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
}) -- }}}
require("presenting").setup({ -- https://github.com/sotte/presenting.nvim {{{
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
}) -- }}}
require("fidget").setup({ -- https://github.com/j-hui/fidget.nvim {{{
  progress = {
    suppress_on_insert = true,
  },
}) -- }}}
