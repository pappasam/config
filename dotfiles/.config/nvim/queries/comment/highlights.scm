;; extends

; Begins or ends with AI? / AI! in comment
((_) @aicomment
 (#match? @aicomment "^[!@#$%^&*\/\-;]+[ \t]*AI[?!]|[ \t]+AI[?!]$")
 (#set! "priority" 128))
