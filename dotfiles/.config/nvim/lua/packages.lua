-- https://github.com/NvChad/nvim-colorizer.lua {{{

require("colorizer").setup()

-- }}}
-- https://github.com/lewis6991/gitsigns.nvim {{{

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
-- https://github.com/windwp/nvim-autopairs {{{

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
  map_c_h = true,
  map_c_w = true,
  map_cr = true,
  enable_check_bracket_line = false,
})

-- BEGIN Rule: add spaces between parentheses
local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
npairs.add_rules({
  Rule(" ", " "):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({
      brackets[1][1] .. brackets[1][2],
      brackets[2][1] .. brackets[2][2],
      brackets[3][1] .. brackets[3][2],
    }, pair)
  end),
})
for _, bracket in pairs(brackets) do
  npairs.add_rules({
    Rule(bracket[1] .. " ", " " .. bracket[2])
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%" .. bracket[2]) ~= nil
      end)
      :use_key(bracket[2]),
  })
end
-- END Rule: add spaces between parentheses

-- }}}
-- https://github.com/kyazdani42/nvim-tree.lua {{{

require("nvim-tree").setup({
  renderer = {
    full_name = true,
  },
  filters = {
    dotfiles = true,
    exclude = {
      "/dotfiles",
    },
  },
})

-- }}}
-- https://github.com/nvim-treesitter/nvim-treesitter {{{

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
    disable = function(lang, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "bash",
    "bibtex",
    "c",
    "c_sharp",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "gdscript",
    "go",
    "gomod",
    "graphql",
    "haskell",
    "hcl",
    "html",
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
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "ocaml",
    "php",
    "prisma",
    "python",
    "query",
    "r",
    "regex",
    "requirements",
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
    "yaml",
  },
})

-- }}}
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring {{{

require("ts_context_commentstring").setup()

-- }}}
-- https://github.com/kyazdani42/nvim-web-devicons {{{

require("nvim-web-devicons").setup({
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
})

-- }}}
-- https://github.com/nvim-telescope/telescope.nvim {{{

local ts = require("telescope")
local actions = require("telescope.actions")

ts.setup({
  defaults = {
    file_ignore_patterns = {
      "^node_modules/",
      "^%.git/",
      "^%.venv/",
    },
    layout_strategy = "flex",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
      },
    },
    prompt_prefix = " ",
  },
})

-- }}}
