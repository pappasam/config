-- Inspiration:
-- https://www.reddit.com/r/neovim/comments/1cxfhom/builtin_snippets_so_good_i_removed_luasnip/

local snippets_by_filetype = {
  html = {
    {
      trigger = "html5",
      body = [[
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title></title>
		<meta name="description" content="My Website" />
		<meta name="author" content="Samuel Roeca" />
		<link rel="stylesheet" href="style/custom.css">
	</head>
	<body>
		$0
	</body>
</html>]],
    },
  },
  make = {
    {
      trigger = "help",
      body = [[
.PHONY: help
help: ## Prints each target and its associated help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*\$\$' \$(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", \$\$1, \$\$2}'
$0]],
    },
    {
      trigger = "phony",
      body = [[
.PHONY: target
target: ## description
	$0]],
    },
  },
  markdown = {
    {
      trigger = "mentor",
      body = [[
Mentor/Mentee Goals Discussion: YYYY-MM-DD

## 1 or 2 abstract goals

$0

## 1 or 2 discrete methods

## 1 of the aforementioned methods]],
    },
    {
      trigger = "shortcut",
      body = [[
## Objective

$0

## Value

## Acceptance Criteria]],
    },
    {
      trigger = "standup",
      body = [[
_Yesterday:_

$0

_Today:_

_Blockers/Reminders:_]],
    },
  },
  sh = {
    { trigger = "set", body = "set -euo pipefail" },
  },
}

local function get_buf_snippets()
  return snippets_by_filetype[vim.bo.filetype] or {}
end

local M = {}

function M.register_cmp_source()
  local cmp_source = {}
  local cache = {}
  function cmp_source.complete(_, _, callback)
    local bufnr = vim.api.nvim_get_current_buf()
    if not cache[bufnr] then
      local completion_items = vim.tbl_map(function(s)
        ---@type lsp.CompletionItem
        local item = {
          word = s.trigger,
          label = s.trigger,
          kind = vim.lsp.protocol.CompletionItemKind.Snippet,
          insertText = s.body,
          insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
        }
        return item
      end, get_buf_snippets())
      cache[bufnr] = completion_items
    end
    callback(cache[bufnr])
  end
  require("cmp").register_source("custom_snippets", cmp_source)
end

return M
