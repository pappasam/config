syntax clear

" Keywords and types
syntax keyword fgaKeyword type relations define module model schema from
syntax keyword fgaType and or
syntax match fgaType "but not"

" Define statements (word being defined as function)
syntax match fgaDefineWord "\vdefine \zs\w+\ze:"

" Operators and delimiters
syntax match fgaOperator ":"
syntax match fgaDelimiter "[\[\](),]"

" Comments
syntax match fgaComment " #.*$"
syntax match fgaComment "^#.*$"

" Link to standard highlighting groups
highlight default link fgaKeyword Keyword
highlight default link fgaType Type
highlight default link fgaOperator Operator
highlight default link fgaDefineWord Function
highlight default link fgaDelimiter Delimiter
highlight default link fgaComment Comment
