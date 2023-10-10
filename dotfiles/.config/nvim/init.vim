" Packages {{{

lua require('packages')

function! s:packager_init(packager) abort
  call a:packager.add('https://github.com/kristijanhusak/vim-packager', {'type': 'opt'})
  " Autocompletion And IDE Features
  call a:packager.add('https://github.com/neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'})
  call a:packager.add('https://github.com/pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' })
  " TreeSitter
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter')
  call a:packager.add('https://github.com/windwp/nvim-ts-autotag')
  call a:packager.add('https://github.com/JoosepAlviste/nvim-ts-context-commentstring', {'name': 'ntcc'}) " required for vim.loader.enable()
  call a:packager.add('https://github.com/tpope/vim-commentary')
  " Tree
  call a:packager.add('https://github.com/kyazdani42/nvim-tree.lua')
  call a:packager.add('https://github.com/kyazdani42/nvim-web-devicons')
  " Fuzzy Finder
  call a:packager.add('https://github.com/nvim-telescope/telescope.nvim')
  call a:packager.add('https://github.com/nvim-lua/plenary.nvim')
  " Git
  call a:packager.add('https://github.com/tpope/vim-fugitive')
  call a:packager.add('https://github.com/lewis6991/gitsigns.nvim')
  " Miscellaneous
  call a:packager.add('https://github.com/pappasam/papercolor-theme-slim')
  call a:packager.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:packager.add('https://github.com/fidian/hexmode')
  call a:packager.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})
  call a:packager.add('https://github.com/pappasam/nvim-repl')
  call a:packager.add('https://github.com/pappasam/vim-filetype-formatter')
  call a:packager.add('https://github.com/sjl/strftimedammit.vim')
  call a:packager.add('https://github.com/windwp/nvim-autopairs')
  call a:packager.add('https://github.com/machakann/vim-sandwich')
endfunction

" }}}
" Settings {{{

aunmenu PopUp.-1-
aunmenu PopUp.How-to\ disable\ mouse
colorscheme PaperColorSlim
digraph '' 699  " Hawaiian character ʻ
set cmdheight=2
set completeopt=menuone,longest wildmode=longest:full
set cursorline
set dictionary=$HOME/config/docs/dict/american-english-with-propcase.txt
set diffopt+=internal,algorithm:patience
set expandtab shiftwidth=2 softtabstop=2
set foldmethod=marker foldnestmax=1
set grepprg=rg\ --vimgrep
set history=10
set isfname+=@-@,:
set list listchars=tab:>\ ,nbsp:+,leadmultispace:\ ,multispace:-
set mouse=a
set noshowcmd
set noshowmode
set noswapfile
set notimeout
set nowrap linebreak
set number
set path+=/usr/include/x86_64-linux-gnu/
set shadafile=NONE
set shortmess+=cI
set showtabline=2
set signcolumn=number
set spelllang=en_us
set splitright
set termguicolors
set updatetime=300
set statusline=%#CursorLine#\ %{mode()}\ %*\ %{&paste?'[P]':''}%{&spell?'[S]':''}%r%t%m
set statusline+=%=%v/%{strwidth(getline('.'))}:%l/%L%y%#CursorLine#\ %{&ff}\ %*\ %{strlen(&fenc)?&fenc:'none'}\  " Trailing space
set tabline=%!CustomTabLine()
function! CustomTabLine()
  let tabnumber_max = tabpagenr('$')
  let tabnumber_current = tabpagenr()
  let s = ''
  for i in range(1, tabnumber_max)
    let s ..= tabnumber_current == i ? '%#TabLineSel#' : '%#TabLine#'
    let s ..= '%' .. i .. 'T' .. ' ' .. i .. ':%{CustomTabLabel(' .. i .. ')}'
    let s ..= tabnumber_max == 1 ? ' ' : '%' .. i .. 'X ✗ %X'
  endfor
  let s ..= '%#TabLineFill#%T%=%#TabLine#%10@CustomTabCloseVim@ ✗ %X'
  return s
endfunction
function! CustomTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let postfix = ''
  for buf in buflist
    if bufname(buf) ==# 'focuswriting_abcdefg'
      let postfix = '🎯'
      break
    endif
  endfor
  let bname = bufname(buflist[winnr - 1])
  let bnamemodified = fnamemodify(bname, ':t')
  if bnamemodified == ''
    return '👻' .. postfix
  elseif bnamemodified =~ 'NvimTree'
    return '🌲' .. postfix
  else
    return bnamemodified .. postfix
  endif
endfunction
function! CustomTabCloseVim(n1, n2, n3, n4)
  quitall
endfunction
let $PATH = $PWD .. '/node_modules/.bin:' .. $PATH
let g:mapleader = ','
let g:clipboard = {
      \ 'name': 'xsel',
      \ 'cache_enabled': 0,
      \ 'copy' : {'+': 'xsel --clipboard --input' , '*': 'xsel --clipboard --input' },
      \ 'paste': {'+': 'xsel --clipboard --output', '*': 'xsel --clipboard --output'},
      \ }
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
" https://github.com/fidian/hexmode
let g:hexmode_patterns = '*.bin,*.exe,*.dat,*.o'
let g:hexmode_xxd_options = '-g 2'
" https://github.com/pappasam/vim-filetype-formatter
let g:vim_filetype_formatter_commands = {
      \ 'python': {-> printf('ruff check -q --fix-only --stdin-filename="%1$s" - | black -q --stdin-filename="%1$s" - | isort -q --filename="%1$s" - | docformatter -', expand('%:p'))},
      \ }
" https://github.com/pappasam/nvim-repl
let g:repl_filetype_commands = {
      \ 'bash': 'bash',
      \ 'javascript': 'node',
      \ 'python': 'ipython --quiet --no-autoindent -i -c "%config InteractiveShell.ast_node_interactivity=\"last_expr_or_assign\""',
      \ 'r': 'R',
      \ 'sh': 'sh',
      \ 'vim': 'nvim --clean -ERM',
      \ 'zsh': 'zsh',
      \ }
let g:repl_default = &shell
" https://github.com/iamcco/markdown-preview.nvim
let g:mkdp_preview_options = {'disable_sync_scroll': 0, 'sync_scroll_type': 'middle'}
" https://github.com/neoclide/coc.nvim
let g:coc_global_extensions = [
      \ '@yaegassy/coc-marksman',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-dictionary',
      \ 'coc-docker',
      \ 'coc-emoji',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-kotlin',
      \ 'coc-lists',
      \ 'coc-ltex',
      \ 'coc-markdownlint',
      \ 'coc-prisma',
      \ 'coc-pyright',
      \ 'coc-r-lsp',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-sumneko-lua',
      \ 'coc-svg',
      \ 'coc-syntax',
      \ 'coc-texlab',
      \ 'coc-toml',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-word',
      \ 'coc-yank',
      \ ]
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
let g:coc_start_at_startup = 1
let g:coc_filetype_map = {
      \ 'markdown.mdx': 'markdown',
      \ 'yaml.ansible': 'yaml',
      \ 'yaml.docker-compose': 'yaml',
      \ 'jinja.html': 'html',
      \ }

" }}}
" Autocmds {{{

augroup bufenter_filetype_assignment
  autocmd!
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf,credentials,.editorconfig set filetype=dosini
  autocmd BufEnter *.config,.cookiecutterrc,DESCRIPTION,.lintr set filetype=yaml
  autocmd BufEnter *.mdx set filetype=markdown
  autocmd BufEnter *.min.js set filetype=none
  autocmd BufEnter *.oct set filetype=octave
  autocmd BufEnter .envrc set filetype=sh
  autocmd BufEnter .dockerignore set filetype=conf
  autocmd BufEnter renv.lock,.jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term,*.htmlhintrc,*.stylelintrc,*.firebaserc set filetype=json
  autocmd BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
augroup end

augroup filetype_custom
  autocmd!
  autocmd Filetype vim call system(['git', 'clone', 'https://github.com/kristijanhusak/vim-packager', $HOME .. '/.config/nvim/pack/packager/opt/vim-packager'])
        \ | packadd vim-packager
        \ | call packager#setup(function('s:packager_init'), {'window_cmd': 'edit'})
        \ | let &l:path .= ','..stdpath('config')..'/lua'
        \ | setlocal suffixesadd^=.lua
  " indentation
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  autocmd Filetype go,gomod,make,snippets,tsv,votl setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " commentstring + comments + formatoptions
  "   commentstring: read by vim-commentary; must be one template
  "   comments: csv of comments.
  "   formatoptions: influences how Vim formats text
  "   ':help fo-table' will get the desired result
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType mermaid setlocal commentstring=\%\%\ %s comments=:\%\%
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
  " iskeyword
  autocmd FileType nginx setlocal iskeyword+=$
  autocmd FileType zsh,sh,css setlocal iskeyword+=-
  autocmd FileType scss setlocal iskeyword+=@-@
  " wrap
  autocmd FileType coctree setlocal nowrap
  " foldenable
  autocmd FileType gitcommit,checkhealth setlocal nofoldenable
  " window opening
  autocmd FileType gitcommit if winnr("$") > 1 | wincmd T | endif
  " override listchars
  autocmd FileType gitcommit
        \ setlocal listchars=tab:>\  " necessary comment for whitespace
  " mappings
  autocmd FileType man,help,qf,coctree
        \ nnoremap <buffer> d <C-d> |
        \ nnoremap <buffer> D <C-d> |
        \ nnoremap <buffer> u <C-u> |
        \ nnoremap <buffer> U <C-u> |
        \ nnoremap <buffer> <C-]> <C-]> |
        \ nnoremap <buffer> q <Cmd>quit<CR>
augroup end

augroup miscellaneous_custom
  autocmd!
  autocmd BufEnter NvimTree* setlocal statusline=\ NvimTree\ %#CursorLine#
  autocmd BufWritePre * TrimWhitespace
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
  autocmd VimEnter * if exists(':NvimTreeOpen') && len(argv()) == 1 && isdirectory(argv(0)) | execute 'NvimTreeOpen ' .. argv(0) | endif
  autocmd VimResized * wincmd =
  " https://github.com/neovim/neovim/issues/20456
  autocmd! ColorScheme,VimEnter *
        \ highlight! link luaParenError Normal |
        \ highlight! link luaError Normal |
        \ highlight! link luaTable Normal
augroup end

" }}}
" Mappings {{{

nnoremap zS <Cmd>Inspect<CR>
nnoremap ' ,
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
nnoremap <A-9> <Cmd>tablast<CR>
nnoremap gx <Cmd>call jobstart(['firefox', expand('<cfile>')])<CR>
xnoremap gx <Cmd>call jobstart(['firefox', line('v') == line('.') ? getline(line('.'))[col('v')-1:col('.')-1] : expand('<cfile>')])<CR><Esc>
xnoremap <Leader>y "+y
nnoremap <Leader>y "+y
noremap <MiddleMouse> <LeftMouse>za
noremap <2-MiddleMouse> <LeftMouse>za
noremap <3-MiddleMouse> <LeftMouse>za
noremap <4-MiddleMouse> <LeftMouse>za
" https://github.com/neoclide/coc.nvim
nmap <C-]> <Plug>(coc-definition)
nnoremap <C-k> <Cmd>call CocActionAsync('doHover')<CR>
inoremap <C-s> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
nnoremap <C-w>f <Cmd>call coc#float#jump()<CR>
nmap <Leader>st <Plug>(coc-type-definition)
nmap <Leader>si <Plug>(coc-implementation)
nmap <Leader>su <Plug>(coc-references)
nmap <Leader>sr <Plug>(coc-rename)
nmap <Leader>sa <Plug>(coc-codeaction-selected)
xmap <Leader>sa <Plug>(coc-codeaction-selected)
inoremap <silent> <expr> <C-Space> coc#refresh()
nnoremap <Leader>d <Cmd>call CocActionAsync('diagnosticToggleBuffer')<CR>
nmap ]g <Plug>(coc-diagnostic-next)
nmap [g <Plug>(coc-diagnostic-prev)
nnoremap <Space>l <Cmd>call CocActionAsync(coc#window#find('cocViewId', 'OUTLINE') == -1 ? 'showOutline' : 'hideOutline')<CR>
" https://github.com/pappasam/nvim-repl
nnoremap <Leader><Leader>e <Cmd>ReplToggle<CR>
nmap <Leader>e <Plug>ReplSendLine
xmap <Leader>e <Plug>ReplSendVisual
" https://github.com/machakann/vim-sandwich
nmap s <Nop>
xmap s <Nop>
" https://github.com/nvim-telescope/telescope.nvim
nnoremap <C-p><C-p> <Cmd>Telescope find_files hidden=true<CR>
nnoremap <C-p><C-b> <Cmd>Telescope buffers<CR>
nnoremap <C-p><C-h> <Cmd>Telescope help_tags<CR>
nnoremap <C-p><C-g> <Cmd>Telescope live_grep<CR>
nnoremap <C-p><C-w> <Cmd>Telescope grep_string<CR>
" https://github.com/pappasam/vim-filetype-formatter
nnoremap <Leader>f <Cmd>silent! CocDisable<CR><Cmd>FiletypeFormat<CR><Cmd>silent! CocEnable<CR>
xnoremap <Leader>f <Cmd>silent! CocDisable<CR>:FiletypeFormat<CR><Cmd>silent! CocEnable<CR>
" https://github.com/kyazdani42/nvim-tree.lua
nnoremap <space>j <Cmd>NvimTreeFindFileToggle<CR>
" Macro Repeater (mr): https://vi.stackexchange.com/questions/11210/can-i-repeat-a-macro-with-the-dot-operator
nnoremap <expr> <Plug>@init <SID>mr_at_init()
inoremap <expr> <Plug>@init "\<c-o>".<SID>mr_at_init()
nnoremap <expr> <Plug>qstop <SID>mr_q_stop()
inoremap <expr> <Plug>qstop "\<c-o>".<SID>mr_q_stop()
nmap <expr> @ <SID>mr_at_reg()
nmap <expr> q <SID>mr_q_start()

function! s:mr_at_repeat(_)
  let s:atcount = v:count ? v:count : s:atcount
  call feedkeys(s:atcount .. '@@')
endfunction
function! s:mr_at_set_repeat(_)
  set operatorfunc=<SID>mr_at_repeat
endfunction
function! s:mr_at_init()
  set operatorfunc=<SID>mr_at_set_repeat
  return 'g@l'
endfunction
function! s:mr_at_reg()
  let s:atcount = v:count1
  return '@' .. nr2char(getchar()) .. "\<plug>@init"
endfunction
function! s:mr_q_repeat(_)
  call feedkeys('@' .. s:qreg)
endfunction
function! s:mr_q_set_repeat(_)
  set operatorfunc=<SID>mr_q_repeat
endfunction
function! s:mr_q_stop()
  set operatorfunc=<SID>mr_q_set_repeat
  return 'g@l'
endfunction
let s:qrec = 0
function! s:mr_q_start()
  if s:qrec == 1
    let s:qrec = 0
    return "q\<plug>qstop"
  endif
  let s:qreg = nr2char(getchar())
  if s:qreg =~# '[0-9a-zA-Z"]'
    let s:qrec = 1
  endif
  return 'q' .. s:qreg
endfunction

" }}}
" Commands {{{

command! Jv edit ~/.config/nvim/init.vim
command! Jc edit ~/.config/nvim/coc-settings.json
command! Jz edit ~/.zshrc
command! Jb edit ~/.bashrc

command! Fit call s:resize_window_width()
function! s:resize_window_width()
  if &wrap
    echo 'run `:set nowrap` before resizing window'
    return
  endif
  let max_length = max(map(range(1, line('$')), "virtcol([v:val, '$'])"))
  let leading_space = getwininfo(win_getid())[0].textoff
  normal! m`
  execute ':vertical resize ' .. (max_length + leading_space)
  normal! ``
endfunction

command! FitHeight call s:resize_window_height()
function! s:resize_window_height()
  normal! m`
  let initial = winnr()
  wincmd k
  if winnr() != initial
    execute initial .. 'wincmd w'
    1
    execute 'resize ' .. (line('$') + 1)
    normal! ``
    return
  endif
  wincmd j
  if winnr() != initial
    execute initial .. 'wincmd w'
    1
    execute 'resize ' .. (line('$') + 1)
    normal! ``
    return
  endif
endfunction

command! Focus call s:focuswriting()
function! s:focuswriting()
  augroup focuswriting
    autocmd!
  augroup end
  let current_buffer = bufnr('%')
  tabe
  try
    file focuswriting_abcdefg
  catch
    edit focuswriting_abcdefg
  endtry
  setlocal nobuflisted
  " Left Window
  call s:focuswriting_settings_side()
  vsplit
  vsplit
  " Right Window
  call s:focuswriting_settings_side()
  wincmd h
  " Middle Window
  vertical resize 88
  execute 'buffer ' .. current_buffer
  call s:focuswriting_settings_middle()
  wincmd =
  augroup focuswriting
    autocmd!
    autocmd WinEnter focuswriting_abcdefg call s:focuswriting_autocmd()
  augroup end
endfunction
function! s:focuswriting_settings_side()
  setlocal nonumber norelativenumber nocursorline fillchars=vert:\ ,eob:\  statusline=\  colorcolumn=0 winhighlight=Normal:NormalFloat
endfunction
function! s:focuswriting_settings_middle()
  setlocal number norelativenumber wrap nocursorline winfixwidth fillchars=vert:\ ,eob:\ ,stlnc:  statusline=\  colorcolumn=0 nofoldenable winhighlight=StatusLine:StatusLineNC
endfunction
function! s:focuswriting_autocmd()
  for windowid in range(1, winnr('$'))
    if bufname(winbufnr(windowid)) != 'focuswriting_abcdefg'
      execute windowid .. 'wincmd w'
      return
    endif
  endfor
  if tabpagenr('$') > 1
    tabclose
  else
    wqall
  endif
endfunction

command! CleanUnicode call s:clean_unicode()
function! s:clean_unicode()
  let save = winsaveview()
  silent! %s/”/"/g
  silent! %s/“/"/g
  silent! %s/’/'/g
  silent! %s/‘/'/g
  silent! %s/—/-/g
  silent! %s/…/.../g
  silent! %s/​//g
  call winrestview(save)
endfunction

command! TrimWhitespace call s:trim_whitespace()
function! s:trim_whitespace()
  let save = winsaveview()
  if &filetype ==? 'markdown'
    " Only trailing spaces, exactly one trailing space, and 2+ trailing spaces
    silent! %s/^\s\+$//e
    silent! %g/\S\s$/s/\s$//g
    silent! %s/\s\s\s\+$/  /e
  else
    silent! %s/\s\+$//e
  endif
  call winrestview(save)
endfunction

command! Preview call s:preview()
function! s:preview()
  if &filetype ==? 'markdown'
    " https://github.com/iamcco/markdown-preview.nvim
    silent! MarkdownPreview
  else
    silent! execute "!gio open '%:p'"
  endif
endfunction

" }}}
