" Taken from <https://github.com/mattn/vim-xxdcursor>

function! s:highlight()
  if exists('s:xxd_cursor_match') && s:xxd_cursor_match != -1
    call matchdelete(s:xxd_cursor_match)
    unlet s:xxd_cursor_match
  endif
  if synIDattr(synID(line('.'), col('.'), 1), 'name') != ''
    return
  endif
  let c = col('.') - 10
  if c % 5 == 0
    return
  endif
  let c = c / 5 * 2 + (c % 5 > 2 ? 1 : 0)
  let s:xxd_cursor_match = matchadd('XXDCursor', '\%' .. (c + 52) .. 'c\%' .. line('.') .. 'l')
endfunction

augroup xxd
  autocmd!
  autocmd CursorMoved <buffer> call s:highlight()
augroup end

highlight link XXDCursor WildMenu
