-- https://neovim.io/doc/user/pack.html#vim.pack {{{

vim.pack.add({
  -- Completion
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("*"),
  },
  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  -- Pairs
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/windwp/nvim-ts-autotag",
  -- Language server protocol (LSP)
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/aerial.nvim",
  -- File pickers
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  -- Git
  "https://github.com/junegunn/gv.vim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  -- My plugins
  "https://github.com/pappasam/nvim-repl",
  "https://github.com/pappasam/papercolor-theme-slim",
  "https://github.com/pappasam/vim-filetype-formatter",
  "https://github.com/pappasam/vim-keywordprg-commands",
  -- Remainder
  "https://github.com/machakann/vim-sandwich",
  "https://github.com/HiPhish/info.vim",
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/chrishrb/gx.nvim",
  "https://github.com/brianhuster/live-preview.nvim",
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
-- https://github.com/nvim-treesitter/nvim-treesitter {{{
-- Manually run the following for new installations -> :TSInstall all

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").fga = {
      install_info = {
        url = "https://github.com/matoous/tree-sitter-fga",
        queries = "queries", -- Also install queries from given directory
      },
    }
  end,
})

-- }}}
-- https://github.com/nvim-tree/nvim-web-devicons {{{

require("nvim-web-devicons").setup({})

-- }}}
-- https://github.com/windwp/nvim-autopairs {{{

require("nvim-autopairs").setup({
  map_c_h = true,
  map_c_w = true,
  map_cr = true,
  enable_check_bracket_line = false,
})

-- }}}
-- https://github.com/windwp/nvim-ts-autotag {{{

require("nvim-ts-autotag").setup()

-- }}}
-- https://github.com/nvim-tree/nvim-tree.lua {{{

local api = require("nvim-tree.api")
local diff_review = require("diff-review")

local function on_attach(bufnr)
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end
  api.map.on_attach.default(bufnr)
  vim.keymap.set("n", "f", function()
    local explorer = require("nvim-tree.core").get_explorer()
    if explorer then
      ---@diagnostic disable-next-line: param-type-mismatch
      explorer:expand_all(nil)
    end
    api.filter.live.start()
  end, opts("Live Filter (recursive)"))
end

require("nvim-tree").setup({
  on_attach = on_attach,
  disable_netrw = true,
  actions = {
    expand_all = {
      exclude = diff_review.disable_folders,
    },
  },
  live_filter = {
    prefix = "  🔍 ",
    always_show_folders = false, -- Turn into false from true by default
  },
  filters = {
    custom = diff_review.tree_custom_filter,
  },
  renderer = {
    full_name = true,
  },
})

diff_review.setup()

-- }}}
-- https://github.com/nvim-telescope/telescope.nvim {{{

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "^node_modules/",
      "^%.git/",
      "^%.venv/",
    },
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
    prompt_prefix = " ",
    wrap_results = true,
  },
  pickers = {
    oldfiles = {
      cwd_only = true,
    },
  },
})

-- }}}
-- https://github.com/lewis6991/gitsigns.nvim {{{

require("gitsigns").setup({
  signcolumn = true,
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
})

-- }}}
-- https://github.com/stevearc/aerial.nvim {{{

require("aerial").setup({})

-- }}}
-- https://github.com/Saghen/blink.cmp {{{

require("blink-cmp").setup({
  enabled = function()
    return not vim.tbl_contains(
      { "NvimTree", "NvimTreeFilter" },
      vim.bo.filetype
    )
  end,
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
-- https://github.com/catgoose/nvim-colorizer.lua {{{

require("colorizer").setup({
  options = {
    parsers = {
      names = {
        enable = false,
      },
    },
  },
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
-- https://github.com/chrishrb/gx.nvim {{{

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
