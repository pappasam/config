;; extends

; Begins or ends with AI? / AI! in comment
((_) @aicomment
 (#match? @aicomment "# AI[?!]|// AI[?!]|-- AI[?!]|[ \t]+AI[?!]$")
 (#set! "priority" 128))
