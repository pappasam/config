" Taken from <https://github.com/mattn/vim-xxdcursor>

function! s:highlight()
  if exists('s:match') && s:match != -1
    call matchdelete(s:match)
    unlet s:match
  endif
  let syn = synIDattr(synID(line('.'), col('.'), 1), 'name')
  if syn != ''
    return
  endif
  let c = col('.') - 10
  if c % 5 == 0
    return
  endif
  let c = c / 5 * 2 + (c % 5 > 2 ? 1 : 0)
  let s:match = matchadd('MyGroup', '\%' . (c+52) . 'c\%' . line('.') . 'l')
endfunction

augroup xxd
  autocmd!
  autocmd CursorMoved <buffer> call s:highlight()
augroup end

highlight link MyGroup WildMenu
