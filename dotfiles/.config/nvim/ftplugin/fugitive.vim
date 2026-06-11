nnoremap <buffer> a <Cmd>Git add .<CR>

function! s:push_ref_name(line) abort
  let l:fields = split(a:line, "\t")
  let l:refspec = get(l:fields, 1, '')
  let l:remote_ref = get(split(l:refspec, ':'), 1, l:refspec)
  return substitute(l:remote_ref, '^refs/heads/', '', '')
endfunction

function! s:push_success_message(output) abort
  let l:pushed_refs = []
  let l:up_to_date = 0
  for l:line in a:output
    if l:line =~# '^=\t'
      let l:up_to_date = 1
    elseif l:line =~# '^[ +*-]\t'
      call add(l:pushed_refs, s:push_ref_name(l:line))
    endif
  endfor
  if !empty(l:pushed_refs)
    return 'git push succeeded: pushed ' .. join(l:pushed_refs, ', ')
  elseif l:up_to_date
    return 'git push succeeded: up to date'
  else
    return 'git push succeeded'
  endif
endfunction

function! s:push_origin_head() abort
  let l:output = systemlist('git push --porcelain -u origin HEAD 2>&1')
  if v:shell_error
    echohl ErrorMsg
    echom 'git push failed'
    echohl None
    for l:line in l:output
      echom l:line
    endfor
  else
    echom s:push_success_message(l:output)
  endif
endfunction

nnoremap <buffer> P <Cmd>call <SID>push_origin_head()<CR>
