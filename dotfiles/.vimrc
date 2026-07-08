" Vim branch field-test config.
" Keep this separate from Neovim: plugins live under ~/.vim/pack/vim-branch.

set nocompatible
let mapleader = ','

if empty($VIMRUNTIME) || !filereadable(expand('$VIMRUNTIME/syntax/syntax.vim'))
  for s:vim_branch_runtime in [expand('~/src/lib/vim/runtime'), expand('~/src/vim/runtime')]
    if filereadable(s:vim_branch_runtime .. '/syntax/syntax.vim')
      let $VIMRUNTIME = s:vim_branch_runtime
      execute 'set runtimepath^=' .. fnameescape(s:vim_branch_runtime)
      execute 'set packpath^=' .. fnameescape(s:vim_branch_runtime)
      break
    endif
  endfor
  unlet! s:vim_branch_runtime
endif

" Native Vim packages are enough here and do not touch Neovim's
" ~/.local/share/nvim/site/pack state.
let g:vim_branch_pack_home = expand('~/.vim/pack/vim-branch/start')
let g:vim_branch_pack_plugins = [
      \ ['lsp', 'https://github.com/yegappan/lsp.git'],
      \ ['papercolor-theme-slim', 'https://github.com/pappasam/papercolor-theme-slim.git'],
      \ ['vim-fugitive', 'https://github.com/tpope/vim-fugitive.git'],
      \ ['gv.vim', 'https://github.com/junegunn/gv.vim.git'],
      \ ['vim-sandwich', 'https://github.com/machakann/vim-sandwich.git'],
      \ ['vim-filetype-formatter', 'https://github.com/pappasam/vim-filetype-formatter.git'],
      \ ['vim-keywordprg-commands', 'https://github.com/pappasam/vim-keywordprg-commands.git'],
      \ ['vim-markdown', 'https://github.com/preservim/vim-markdown.git'],
      \ ['nerdtree', 'https://github.com/preservim/nerdtree.git'],
      \ ['ctrlp.vim', 'https://github.com/ctrlpvim/ctrlp.vim.git'],
      \ ]

command! P PackUpdate
command! PackUpdate call s:pack_update()
function! s:pack_update() abort
  if !executable('git')
    echoerr 'git is required for :PackUpdate'
    return
  endif

  call mkdir(g:vim_branch_pack_home, 'p')
  for [name, url] in g:vim_branch_pack_plugins
    let dir = g:vim_branch_pack_home .. '/' .. name
    if isdirectory(dir .. '/.git')
      execute '!git -C ' .. shellescape(dir) .. ' pull --ff-only'
    elseif !isdirectory(dir)
      execute '!git clone --depth=1 ' .. shellescape(url) .. ' ' .. shellescape(dir)
    endif
  endfor

  packloadall
  silent! helptags ALL
  echo 'Vim branch test plugins are up to date'
endfunction

" Commands {{{1

command! Fit call s:resize_window_width()
function! s:resize_window_width() abort
  set lazyredraw
  try
    let max_length = max(map(range(1, line('$')), "virtcol([v:val, '$'])"))
    let leading_space = getwininfo(win_getid())[0].textoff
    normal! ma
    execute 'vertical resize ' .. (max_length + leading_space)
    normal! `a
  finally
    set nolazyredraw
  endtry
endfunction

command! CleanUnicode call s:clean_unicode()
function! s:clean_unicode() abort
  set lazyredraw
  try
    let save = winsaveview()
    silent! %substitute/”/"/g
    silent! %substitute/“/"/g
    silent! %substitute/’/'/g
    silent! %substitute/‘/'/g
    silent! %substitute/—/ - /g
    silent! %substitute/…/.../g
    silent! %substitute/​//g
    silent! %substitute/–/-/g
    silent! %substitute/‐/-/g
    silent! %substitute/ / /g
    silent! %substitute/　/ /g
    silent! %substitute/′/'/g
    silent! %substitute/″/"/g
    silent! %substitute/•/*/g
    silent! %substitute/·/*/g
    silent! %substitute/°/^/g
    silent! %substitute/™/(tm)/g
    silent! %substitute/©/(c)/g
    silent! %substitute/®/(r)/g
    silent! %substitute/×/x/g
    silent! %substitute/÷/\//g
    silent! %substitute/±/+\/-/g
    silent! %substitute/½/1\/2/g
    silent! %substitute/¼/1\/4/g
    silent! %substitute/¾/3\/4/g
    silent! %substitute/‽/?!/g
    silent! %substitute/¿/?/g
    silent! %substitute/¡/!/g
    call winrestview(save)
  finally
    set nolazyredraw
  endtry
endfunction

command! ResizeTabs call s:resize_tabs()
function! s:resize_tabs() abort
  set lazyredraw
  try
    let current_tab = tabpagenr()
    tabdo wincmd =
    execute 'tabnext ' .. current_tab
  finally
    set nolazyredraw
  endtry
endfunction

command! TrimWhitespace call s:trim_whitespace()
function! s:trim_whitespace() abort
  set lazyredraw
  try
    let save = winsaveview()
    if &filetype ==? 'markdown'
      silent!              %substitute/^\s\+$//e
      silent! %global/\S\s$/substitute/\s$//g
      silent!              %substitute/\s\s\s\+$/  /e
    else
      silent! %substitute/\s\+$//e
    endif
    call winrestview(save)
  finally
    set nolazyredraw
  endtry
endfunction

command! -bang Conceal call s:conceal('<bang>')
function! s:conceal(bang) abort
  if !has('conceal')
    echo 'This Vim was built without +conceal'
    return
  endif

  if a:bang ==# '!'
    setlocal conceallevel=0
    setlocal concealcursor=
  else
    setlocal conceallevel=3
    setlocal concealcursor=nc
  endif
endfunction

command! CtrlL call s:ctrl_l()
function! s:ctrl_l() abort
  silent! LspHighlightClear
  diffupdate
  let @/ = ''
  redraw!
endfunction

command! -range C <line1>,<line2>call s:copy_reference(<range>)
function! s:copy_reference(range_type) range abort
  let file_path = expand('%:p')
  if file_path ==# ''
    echohl WarningMsg | echo 'No file to copy' | echohl None
    return
  endif

  if a:range_type == 0
    let reference = file_path
  elseif a:firstline == a:lastline
    let reference = file_path .. ':' .. a:firstline
  else
    let reference = file_path .. ':' .. a:firstline .. '-' .. a:lastline
  endif

  call setreg('+', reference)
  echo 'Copied: ' .. reference
endfunction

command! PopupWord call s:popup_word()
function! s:popup_word() abort
  let word = expand('<cword>')
  if word ==# ''
    echo 'No word under cursor'
    return
  endif

  call s:popup_at_cursor([
        \ expand('%:t') .. ':' .. line('.') .. ':' .. col('.'),
        \ word,
        \ 'screenpos()=' .. string(screenpos(winnr(), line('.'), col('.'))),
        \ ], ' Vim branch hover ')
endfunction

function! s:popup_at_cursor(lines, title) abort
  if exists('*popup_atcursor')
    call popup_atcursor(a:lines, {
          \ 'moved': 'word',
          \ 'padding': [0, 1, 0, 1],
          \ 'border': [],
          \ 'title': a:title,
          \ 'maxwidth': 78,
          \ 'wrap': v:true,
          \ 'mapping': v:false,
          \ })
  else
    echo join(a:lines, "\n")
  endif
endfunction

function! s:hover() abort
  if exists(':LspHover') == 2
    LspHover
  else
    call s:popup_word()
  endif
endfunction

let g:vim_branch_beval_winid = 0
let g:vim_branch_beval_last_text = ''
function! VimBranchBalloonExpr() abort
  let text = v:beval_text
  if text ==# ''
    return ''
  endif

  if exists('*popup_beval')
    if g:vim_branch_beval_winid > 0
          \ && !empty(popup_getpos(g:vim_branch_beval_winid))
      if text ==# g:vim_branch_beval_last_text
        return ''
      endif
      call popup_close(g:vim_branch_beval_winid)
    endif

    let lines = [
          \ fnamemodify(bufname(v:beval_bufnr), ':~:.')
          \   .. ':' .. v:beval_lnum .. ':' .. v:beval_col,
          \ text,
          \ ]
    let g:vim_branch_beval_winid = popup_beval(lines, {
          \ 'mousemoved': 'word',
          \ 'padding': [0, 1, 0, 1],
          \ 'border': [],
          \ 'maxwidth': 78,
          \ 'wrap': v:true,
          \ 'mapping': v:false,
          \ })
    let g:vim_branch_beval_last_text = text
    return ''
  endif

  return fnamemodify(bufname(v:beval_bufnr), ':~:.')
        \ .. ':' .. v:beval_lnum .. ':' .. v:beval_col
        \ .. "\n" .. text
endfunction

function! s:tree_toggle() abort
  if exists(':NERDTreeToggle') == 2
    NERDTreeToggle
  else
    Explore
  endif
endfunction

silent! colorscheme PaperColorSlim

function! s:lsp_setup() abort
  if exists('*LspOptionsSet')
    call LspOptionsSet({
          \ 'autoComplete': v:true,
          \ 'autoHighlight': v:true,
          \ 'autoHighlightDiags': v:true,
          \ 'completionInPreview': v:false,
          \ 'hoverInPreview': v:false,
          \ 'popupBorder': v:true,
          \ 'showDiagInBalloon': v:true,
          \ 'showDiagInPopup': v:true,
          \ 'showDiagWithSign': v:true,
          \ 'showDiagWithVirtualText': v:false,
          \ })
  endif

  if !exists('*LspAddServer')
    return
  endif

  let servers = []
  if executable('clangd')
    call add(servers, {
          \ 'name': 'clangd',
          \ 'filetype': ['c', 'cpp'],
          \ 'path': exepath('clangd'),
          \ 'args': ['--background-index'],
          \ })
  endif
  if executable('typescript-language-server')
    call add(servers, {
          \ 'name': 'typescript-language-server',
          \ 'filetype': ['javascript', 'javascriptreact', 'typescript',
          \              'typescriptreact'],
          \ 'path': exepath('typescript-language-server'),
          \ 'args': ['--stdio'],
          \ })
  endif
  if executable('gopls')
    call add(servers, {
          \ 'name': 'gopls',
          \ 'filetype': ['go', 'gomod'],
          \ 'path': exepath('gopls'),
          \ 'args': ['serve'],
          \ 'syncInit': v:true,
          \ })
  endif
  if executable('rust-analyzer')
    call add(servers, {
          \ 'name': 'rust-analyzer',
          \ 'filetype': ['rust'],
          \ 'path': exepath('rust-analyzer'),
          \ 'args': [],
          \ 'syncInit': v:true,
          \ })
  endif
  if executable('basedpyright-langserver')
    call add(servers, {
          \ 'name': 'basedpyright',
          \ 'filetype': ['python'],
          \ 'path': exepath('basedpyright-langserver'),
          \ 'args': ['--stdio'],
          \ })
  elseif executable('pyright-langserver')
    call add(servers, {
          \ 'name': 'pyright',
          \ 'filetype': ['python'],
          \ 'path': exepath('pyright-langserver'),
          \ 'args': ['--stdio'],
          \ })
  endif
  if executable('vim-language-server')
    call add(servers, {
          \ 'name': 'vim-language-server',
          \ 'filetype': ['vim'],
          \ 'path': exepath('vim-language-server'),
          \ 'args': ['--stdio'],
          \ })
  endif

  if !empty(servers)
    call LspAddServer(servers)
  endif
endfunction

" Mappings {{{1

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>
cnoremap <C-u> <C-E><C-U>
nnoremap ' ,
nnoremap <C-Space> <Nop>
inoremap <C-Space> <Nop>
snoremap <C-Space> <Nop>
xnoremap <C-Space> <Nop>
cnoremap <C-Space> <Nop>
nnoremap <C-@> <Nop>
inoremap <C-@> <Nop>
snoremap <C-@> <Nop>
xnoremap <C-@> <Nop>
cnoremap <C-@> <Nop>
nnoremap <Nul> <Nop>
inoremap <Nul> <Nop>
snoremap <Nul> <Nop>
xnoremap <Nul> <Nop>
cnoremap <Nul> <Nop>
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> J v:count == 0 ? '<esc>' : 'J'
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> :tablast<CR>
nnoremap <Leader>eb :edit ~/config/dotfiles/.bashrc<CR>
nnoremap <Leader>ek :edit ~/config/dotfiles/.config/kitty/kitty.conf<CR>
nnoremap <Leader>em :edit ~/config/dotfiles/.config/mise/config.toml<CR>
nnoremap <Leader>ep :edit ~/config/docs/samples/ai-prompts.md<CR>
nnoremap <Leader>ev :edit ~/config/dotfiles/.vimrc<CR>
nnoremap <Leader>ez :edit ~/config/dotfiles/.zshrc<CR>
xnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <expr> za line('.') == 1 ? 'za' : 'kjza'
nnoremap K :call <SID>hover()<CR>
nnoremap <C-k> :call <SID>hover()<CR>
nnoremap grd :silent! LspDiag current<CR>
nnoremap grD :silent! LspDiag show<CR>
nnoremap <C-h> :silent! LspHighlight<CR>
nnoremap <C-l> :CtrlL<CR>
nmap s <Nop>
xmap s <Nop>
nnoremap <Space>j :call <SID>tree_toggle()<CR>
nnoremap <Space>f :call <SID>tree_toggle()<CR>
nnoremap <Leader>gg :Gdiffsplit<CR>
nnoremap <Leader>gh :diffget<CR>
nnoremap <Leader>gu :diffput<CR>
nnoremap <C-t><C-b> :buffers<CR>:buffer<Space>
nnoremap <C-t><C-f> :grep<Space>
nnoremap <C-t><C-h> :helpgrep<Space>
nnoremap <C-t><C-o> :oldfiles<CR>:edit<Space>
nnoremap <C-t><C-t> :find<Space>
nnoremap <Leader>f :FiletypeFormat<CR>
xnoremap <Leader>f :FiletypeFormat<CR>

" Autocmds {{{1

augroup vim_branch_test
  autocmd!
  autocmd BufRead,BufNewFile *.murmure set filetype=json
  autocmd BufRead,BufNewFile */.github/workflows/*.yml,*/.github/workflows/*.yaml set filetype=yaml.ghactions
  autocmd BufRead,BufNewFile *.min.js set filetype=none
  autocmd BufRead,BufNewFile *.{1p,1pm,2pm,3pm,4pm,5pm} set filetype=nroff
  autocmd BufRead,BufNewFile *.log set filetype=log
  autocmd BufWritePre * TrimWhitespace
  autocmd TextYankPost * silent! call popup_create('yanked', {'time': 250, 'line': 'cursor+1', 'col': 'cursor', 'moved': 'any'})
  autocmd VimResized * ResizeTabs
  autocmd User LspSetup call s:lsp_setup()
augroup end

" Settings {{{1

filetype plugin indent on
syntax enable

if has('termguicolors')
  set termguicolors
endif
if exists('+completepopup')
  set completepopup=height:12,border:round,highlight:Pmenu
endif

if has('conceal')
  set conceallevel=3
  set concealcursor=nc
endif
if has('balloon_eval_term')
  set noballoonevalterm
  set balloondelay=250
  set balloonexpr=VimBranchBalloonExpr()
endif

set completeopt=menuone,longest
silent! set completeopt+=popup
silent! set completeopt+=fuzzy
set wildmode=longest:full
set cursorline
if exists('+cursorlineopt')
  set cursorlineopt=number
endif
silent! set diffopt+=algorithm:histogram
silent! set diffopt+=indent-heuristic
silent! set diffopt+=inline:word
set expandtab shiftwidth=2 softtabstop=2
set exrc secure
set foldmethod=marker foldnestmax=1
set foldcolumn=1
if executable('rg')
  set grepprg=rg\ --vimgrep
endif
set ignorecase smartcase
set isfname+=@-@,:
set linebreak breakat=\ \	,])/- breakindent breakindentopt=list:-1
set mouse=a
set noshowcmd
set noshowmode
set noswapfile
set notimeout
set number
set path+=/usr/include/x86_64-linux-gnu/
set shortmess+=c
set showtabline=2
set signcolumn=yes
set spelllang=en_us
set splitright
set updatetime=300
if exists('+winborder')
  set winborder=rounded
endif

let $PATH = getcwd() .. '/node_modules/.bin:' .. $PATH
let g:clipboard = 'xsel'
let g:markdown_recommended_style = 0
let g:markdown_syntax_conceal = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 1
let g:vim_markdown_conceal_code_blocks = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
let g:tex_conceal = 'abdmgsS'
let g:vim_json_conceal = 1
let g:tex_flavor = 'latex'
let g:vim_filetype_formatter_ft_maps = {'yaml.ghactions': 'yaml'}
let g:NERDTreeShowHidden = 1
let g:ctrlp_user_command = executable('rg') ? 'rg --files --hidden --glob !.git' : ''

" vim:foldmethod=marker:foldlevel=0:
