function! s:quickfix_vsplit()
  set lazyredraw
  try
    execute "normal \<CR>"
    vsplit
    wincmd h
    execute "normal \<C-o>"
    wincmd l
  finally
    set nolazyredraw
  endtry
endfunction

function! s:quickfix_split()
  set lazyredraw
  try
    execute "normal \<CR>"
    split
    wincmd j
    execute "normal \<C-o>"
    wincmd k
  finally
    set nolazyredraw
  endtry
endfunction

function! s:quickfix_tabedit()
  set lazyredraw
  try
    execute "normal \<CR>"
    split
    wincmd j
    execute "normal \<C-o>"
    wincmd k
    wincmd T
    wincmd gT
    wincmd j
    wincmd gt
  finally
    set nolazyredraw
  endtry
endfunction

nnoremap <buffer> <C-v> <Cmd>call <SID>quickfix_vsplit()<CR>
nnoremap <buffer> <C-x> <Cmd>call <SID>quickfix_split()<CR>
nnoremap <buffer> <C-t> <Cmd>call <SID>quickfix_tabedit()<CR>
