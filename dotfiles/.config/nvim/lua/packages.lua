-- https://neovim.io/doc/user/pack.html#vim.pack {{{

vim.pack.add({
  -- Completion
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("*"),
  },
  -- Treesitter
  "https://github.com/romus204/tree-sitter-manager.nvim",
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
  -- Scrollbar
  "https://github.com/dstein64/nvim-scrollview",
  -- My plugins
  "https://github.com/pappasam/nvim-repl",
  "https://github.com/pappasam/papercolor-theme-slim",
  "https://github.com/pappasam/vim-filetype-formatter",
  "https://github.com/pappasam/vim-keywordprg-commands",
  -- Remainder
  "https://github.com/machakann/vim-sandwich",
  "https://github.com/HiPhish/info.vim",
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/brianhuster/live-preview.nvim",
})

-- }}}
-- https://github.com/romus204/tree-sitter-manager.nvim {{{

require("tree-sitter-manager").setup({
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "console",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "dot",
    "ecma",
    "editorconfig",
    "fga",
    "git_config",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "haskell",
    "hcl",
    "html",
    "html_tags",
    "javascript",
    "json",
    "json5",
    "jsx",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "python",
    "query",
    "regex",
    "ruby",
    "rust",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zsh",
  },
  languages = {
    console = {
      install_info = {
        url = "/home/sroeca/src/pappasam/tree-sitter-console",
        revision = false,
        branch = "main",
        use_repo_queries = true,
      },
    },
    fga = {
      install_info = {
        url = "https://github.com/matoous/tree-sitter-fga",
        revision = false,
        branch = "main",
        use_repo_queries = true,
      },
    },
    mermaid = {
      install_info = {
        url = "/home/sroeca/src/pappasam/tree-sitter-mermaid",
        revision = false,
        branch = "main",
        use_repo_queries = true,
      },
    },
  },
  auto_install = false,
  highlight = false,
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
    git_ignored = false,
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
    local function center_after_hunk_jump()
      vim.defer_fn(function()
        vim.cmd("normal! z.")
      end, 50)
    end
    map("n", "]g", function()
      if vim.wo.diff then
        return "]g"
      end
      vim.schedule(function()
        gs.next_hunk()
        center_after_hunk_jump()
      end)
      return "<Ignore>"
    end, { expr = true })
    map("n", "[g", function()
      if vim.wo.diff then
        return "[g"
      end
      vim.schedule(function()
        gs.prev_hunk()
        center_after_hunk_jump()
      end)
      return "<Ignore>"
    end, { expr = true })
  end,
})

-- }}}
-- https://github.com/dstein64/nvim-scrollview {{{

require("scrollview").setup({
  current_only = true,
  excluded_filetypes = {
    "NvimTree",
    "TelescopePrompt",
    "aerial",
  },
  floating_windows = false,
  mode = "proper",
  on_startup = false,
  signs_on_startup = {},
  visibility = "overflow",
  winblend = 60,
  winblend_gui = 45,
})

vim.opt.mousemoveevent = true

local scrollview_hide_timer
local scrollview_mouse_down = false
local scrollview_visible = false
local scrollview_schedule_hide

local function scrollview_cmd(command)
  vim.cmd("silent! " .. command)
end

local function scrollview_stop_hide_timer()
  if scrollview_hide_timer then
    scrollview_hide_timer:stop()
  end
end

local function scrollview_show()
  if not scrollview_visible then
    scrollview_cmd("ScrollViewEnable")
    scrollview_visible = true
  end
end

local function scrollview_hide()
  if scrollview_mouse_down then
    scrollview_schedule_hide(250)
    return
  end

  if scrollview_visible then
    scrollview_cmd("ScrollViewDisable")
    scrollview_visible = false
  end
end

scrollview_schedule_hide = function(delay_ms)
  if scrollview_hide_timer then
    scrollview_hide_timer:stop()
  else
    scrollview_hide_timer = vim.uv.new_timer()
  end

  scrollview_hide_timer:start(delay_ms, 0, function()
    vim.schedule(scrollview_hide)
  end)
end

local function scrollview_termcode(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

local scrollview_mousemove = scrollview_termcode("<mousemove>")
local scrollview_leftmouse = scrollview_termcode("<leftmouse>")
local scrollview_leftdrag = scrollview_termcode("<leftdrag>")
local scrollview_leftrelease = scrollview_termcode("<leftrelease>")

vim.on_key(function(char)
  if string.find(char, scrollview_leftmouse, 1, true) then
    scrollview_mouse_down = true
    scrollview_stop_hide_timer()
    return
  end

  if string.find(char, scrollview_leftdrag, 1, true) then
    scrollview_mouse_down = true
    scrollview_stop_hide_timer()
    return
  end

  if string.find(char, scrollview_leftrelease, 1, true) then
    scrollview_mouse_down = false
    scrollview_schedule_hide(1000)
    return
  end

  if string.find(char, scrollview_mousemove, 1, true) then
    vim.schedule(function()
      scrollview_show()
      scrollview_schedule_hide(1000)
    end)
  end
end, vim.api.nvim_create_namespace("scrollview_hover"))

vim.api.nvim_create_autocmd({ "VimLeavePre", "WinClosed" }, {
  group = vim.api.nvim_create_augroup("scrollview_hover", {
    clear = true,
  }),
  callback = function()
    scrollview_stop_hide_timer()
    scrollview_cmd("ScrollViewDisable")
    scrollview_visible = false
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
  keymap = {
    preset = "default",
    ["<C-space>"] = false,
  },
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

-- https://github.com/saghen/blink.cmp/pull/2266
vim.keymap.set("i", "<C-x><C-o>", function()
  require("blink-cmp").show()
end, {
  desc = "blink.cmp: Show",
  silent = true,
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
