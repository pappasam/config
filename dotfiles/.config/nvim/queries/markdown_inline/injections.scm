((html_tag) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined))

; Disables latex injection by omitting it (below for documentation's sake)
; See: help treesitter-language-injections
; ((latex_block) @injection.content
;   (#set! injection.language "latex")
;   (#set! injection.include-children))
