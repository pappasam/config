local global_snippets = {
  { trigger = "shebang", body = "#!/bin/sh" },
}

local snippets_by_filetype = {
  html = {
    {
      trigger = "html5",
      body = [[
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title>${1:My great website}</title>
		<meta name="description" content="${2:The greatest website on earth}" />
		<meta name="author" content="${3:Samuel Roeca}" />
		<link rel="stylesheet" href="${4:style/custom.css}">
	</head>
	<body>
		$0
	</body>
</html>
      ]],
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
$1
      ]],
    },
    {
      trigger = "phony",
      body = [[
.PHONY: $1
$1: ## ${2:Description}
	$0
      ]],
    },
  },
  markdown = {
    {
      trigger = "mentor",
      body = [[
Mentor/Mentee Goals Discussion: ${1:YYYY-MM-DD}

## 1 or 2 abstract goals

- ${2:Goals}

## 1 or 2 discrete methods

- ${3:Discrete_Methods}

## 1 of the aforementioned methods

- ${4:Aforementioned_Methods}
    ]],
    },
    {
      trigger = "shortcut",
      body = [[
## Objective

${1}

## Value

${2}

## Acceptance Criteria

${3}
      ]],
    },
    {
      trigger = "standup",
      body = [[
_Yesterday:_

- ${1}

_Today:_

- ${2}

_Blockers/Reminders:_

- ${3}
      ]],
    },
  },
  sh = {
    { trigger = "set", body = "set -euo pipefail" },
  },
}

local function get_buf_snips()
  local ft = vim.bo.filetype
  local snips = vim.list_slice(global_snippets)

  if ft and snippets_by_filetype[ft] then
    vim.list_extend(snips, snippets_by_filetype[ft])
  end

  return snips
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
      end, get_buf_snips())

      cache[bufnr] = completion_items
    end

    callback(cache[bufnr])
  end

  require("cmp").register_source("snp", cmp_source)
end

return M
