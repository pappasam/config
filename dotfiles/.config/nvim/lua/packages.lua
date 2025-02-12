-- Language Servers: https://github.com/neovim/nvim-lspconfig {{{
-- :help lsp.txt
-- :help diagnostic.txt

local language_servers = {
  bashls = {},
  cssls = {},
  dockerls = {},
  gopls = {},
  graphql = {},
  html = {},
  jsonls = {},
  ltex_plus = {
    filetypes = {
      "bib",
      "markdown",
      "markdown.mdx",
      "org",
      "pandoc",
      "plaintex",
      "quarto",
      "rmd",
      "rnoweb",
      "rst",
      "tex",
    },
    settings = {
      ltex = {
        language = "en-US",
        checkFrequency = "save",
        disabledRules = {
          ["en-US"] = {
            "ENGLISH_WORD_REPEAT_BEGINNING_RULE",
            "ENGLISH_WORD_REPEAT_RULE",
            "EN_QUOTES",
            "FILE_EXTENSIONS_CASE",
            "MORFOLOGIK_RULE_EN_US",
            "PHRASE_REPETITION",
            "UPPERCASE_SENTENCE_START",
            "WHITESPACE_RULE",
          },
        },
      },
    },
  },
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
  pyright = {},
  r_language_server = {},
  rust_analyzer = {},
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

-- }}}
require("render-markdown").setup({ -- https://github.com/MeanderingProgrammer/render-markdown.nvim {{{
  file_types = { "Avante", "markdown" },
  render_modes = true,
  sign = {
    enabled = false,
  },
  anti_conceal = {
    enabled = false,
  },
  win_options = {
    concealcursor = {
      default = "nvic",
      rendered = "nvic",
    },
  },
  heading = {
    backgrounds = {
      "pcsHtmlHeader1",
      "pcsHtmlHeader2",
      "pcsHtmlHeader3",
      "pcsHtmlHeader4",
      "pcsHtmlHeader5",
      "pcsHtmlHeader6",
    },
    foregrounds = {
      "pcsHtmlHeader1",
      "pcsHtmlHeader2",
      "pcsHtmlHeader3",
      "pcsHtmlHeader4",
      "pcsHtmlHeader5",
      "pcsHtmlHeader6",
    },
  },
  bullet = {
    highlight = "Delimiter",
  },
  code = {
    style = "language",
    disable_background = true,
    left_pad = 2,
    width = "block",
    border = "none",
  },
}) -- }}}
require("nvim-tree").setup({ -- https://github.com/kyazdani42/nvim-tree.lua {{{
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
  view = {
    signcolumn = "no",
  },
  renderer = {
    full_name = true,
    symlink_destination = false,
    root_folder_label = false,
  },
}) -- }}}
require("aerial").setup({ -- https://github.com/stevearc/aerial.nvim {{{
}) -- }}}
require("blink-cmp").setup({ -- https://github.com/Saghen/blink.cmp {{{
  sources = {
    cmdline = {}, -- disables cmdline completions
  },
}) -- }}}
require("colorizer").setup({ -- https://github.com/catgoose/nvim-colorizer.lua {{{
}) -- }}}
require("faster").setup({ -- https://github.com/pteroctopus/faster.nvim {{{
}) -- }}}
require("fidget").setup({ -- https://github.com/j-hui/fidget.nvim {{{
  progress = {
    suppress_on_insert = true,
  },
}) -- }}}
require("gitsigns").setup({ -- https://github.com/lewis6991/gitsigns.nvim {{{
  signcolumn = false,
  numhl = true,
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

    -- Actions
    map({ "n", "v" }, "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>")
    map("n", "<leader>hS", gs.stage_buffer)
    map("n", "<leader>hu", gs.undo_stage_hunk)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end)
    map("n", "<leader>tb", gs.toggle_current_line_blame)
    map("n", "<leader>hd", gs.diffthis)
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end)
    map("n", "<leader>td", gs.toggle_deleted)

    -- Text object
    map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>")
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
require("ibl").setup({ -- https://github.com/lukas-reineke/indent-blankline.nvim {{{
  indent = {
    char = "▏",
  },
  scope = {
    enabled = false,
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
require("telescope").setup({ -- https://github.com/nvim-telescope/telescope.nvim {{{
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
}) -- }}}
-- AI (Avante): {{{ -- https://github.com/yetone/avante.nvim

require("avante_lib").load()
require("avante").setup({
  provider = vim.env.AVANTE_PROVIDER or "claude",
  bedrock = { -- configuration if using bedrock
    model = "anthropic.claude-3-5-sonnet-20241022-v2:0",
  },
})

-- }}}
