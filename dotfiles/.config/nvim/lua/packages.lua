-- lsp {{{
-- https://github.com/neovim/nvim-lspconfig
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
  ltex = {
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
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
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
          ["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "/*docker-compose.yml",
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
-- aerial.nvim {{{
-- https://github.com/stevearc/aerial.nvim

require("aerial").setup({})

-- }}}
-- blink.cmp {{{
-- https://github.com/Saghen/blink.cmp

require("blink-cmp").setup({
  keymap = {
    accept = "<C-y>",
    scroll_documentation_up = "<C-k>",
    scroll_documentation_down = "<C-j>",
    snippet_forward = "<C-j>",
    snippet_backward = "<C-k>",
  },
})

-- }}}
-- fidget.nvim {{{
-- https://github.com/j-hui/fidget.nvim
require("fidget").setup({
  progress = {
    suppress_on_insert = true,
  },
})

-- }}}
-- gitsigns.nvim {{{
-- https://github.com/lewis6991/gitsigns.nvim

require("gitsigns").setup({
  attach_to_untracked = false,
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
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
})

-- }}}
-- gx.nvim {{{
-- https://github.com/chrishrb/gx.nvim

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
})

-- }}}
-- indent-blankline.nvim {{{
-- https://github.com/lukas-reineke/indent-blankline.nvim

require("ibl").setup({
  indent = {
    char = "▏",
  },
  scope = {
    show_start = false,
    show_end = false,
  },
})

-- }}}
-- nvim-autopairs {{{
-- https://github.com/windwp/nvim-autopairs

require("nvim-autopairs").setup({
  map_c_h = true,
  map_c_w = true,
  map_cr = true,
  enable_check_bracket_line = false,
})

-- }}}
-- nvim-colorizer.lua {{{
-- https://github.com/NvChad/nvim-colorizer.lua

require("colorizer").setup({
  filetypes = { "*" },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue or blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
  },
})

-- }}}
-- nvim-tree.lua {{{
-- https://github.com/kyazdani42/nvim-tree.lua

require("nvim-tree").setup({
  disable_netrw = true,
  renderer = {
    full_name = true,
    symlink_destination = false,
    root_folder_label = false,
  },
  filters = {
    dotfiles = true,
    exclude = {
      "/.github",
      "/dotfiles",
    },
  },
})

-- }}}
-- nvim-treesitter {{{
-- https://github.com/nvim-treesitter/nvim-treesitter

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
    "vimdoc",
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
-- nvim-ts-autotag {{{
-- https://github.com/windwp/nvim-ts-autotag

require("nvim-ts-autotag").setup()

-- }}}
-- nvim-web-devicons {{{
-- https://github.com/kyazdani42/nvim-web-devicons

require("nvim-web-devicons").setup({
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
})

-- }}}
-- presenting.nvim {{{
-- https://github.com/sotte/presenting.nvim

require("presenting").setup({
  options = {
    width = 60,
  },
  separator = {
    markdown = "^#+ ",
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
-- telescope.nvim {{{
-- https://github.com/nvim-telescope/telescope.nvim

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "^node_modules/",
      "^%.git/",
      "^%.venv/",
    },
    layout_strategy = "flex",
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
    prompt_prefix = " ",
  },
})

-- }}}
