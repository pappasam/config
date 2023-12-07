" Packages {{{

lua require('packages') -- ~/.config/nvim/lua/packages.lua

function! s:packager_init(packager) abort
  call a:packager.add('https://github.com/kristijanhusak/vim-packager', {'type': 'opt'})
  " Language Server (LSP)
  call a:packager.add('https://github.com/neovim/nvim-lspconfig')
  call a:packager.add('https://github.com/hedyhli/outline.nvim')
  " Autocompletion
  call a:packager.add('https://github.com/hrsh7th/nvim-cmp')
  call a:packager.add('https://github.com/hrsh7th/cmp-nvim-lsp')
  call a:packager.add('https://github.com/hrsh7th/cmp-buffer')
  call a:packager.add('https://github.com/hrsh7th/cmp-path')
  call a:packager.add('https://github.com/hrsh7th/cmp-emoji')
  call a:packager.add('https://github.com/hrsh7th/vim-vsnip')
  call a:packager.add('https://github.com/hrsh7th/cmp-vsnip')
  " Tree Sitter
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter')
  call a:packager.add('https://github.com/windwp/nvim-ts-autotag')
  call a:packager.add('https://github.com/JoosepAlviste/nvim-ts-context-commentstring')
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
  call a:packager.add('https://github.com/Glench/Vim-Jinja2-Syntax')
  call a:packager.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:packager.add('https://github.com/fidian/hexmode')
  call a:packager.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})
  call a:packager.add('https://github.com/pappasam/nvim-repl')
  call a:packager.add('https://github.com/pappasam/vim-filetype-formatter')
  call a:packager.add('https://github.com/windwp/nvim-autopairs')
  call a:packager.add('https://github.com/machakann/vim-sandwich')
  call a:packager.add('https://github.com/HiPhish/info.vim')
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
set list listchars=tab:>\ ,nbsp:+,lead:│,multispace:-
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
set statusline=%#CursorLine#\ %{mode()}\ %*\ %{&paste?'[P]':''}%{&spell?'[S]':''}%r%t%m%{get(b:,'gitsigns_status','')}
set statusline+=%=%v/%{strwidth(getline('.'))}:%l/%L%y%#CursorLine#\ %{&ff}\ %*\ %{strlen(&fenc)?&fenc:'none'}\  " Trailing space
set tabline=%!CustomTabLine()
function! CustomTabLine()
  let tabnumber_max = tabpagenr('$')
  let tabnumber_current = tabpagenr()
  let s = ''
  for i in range(1, tabnumber_max)
    let s ..= tabnumber_current == i ? '%#TabLineSel#' : '%#TabLine#'
    let s ..= '%' .. i .. 'T' .. ' ' .. i .. ':%{CustomTabLabel(' .. i .. ')} '
  endfor
  let s ..= '%#TabLineFill#%T%=%#TabLine#'
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
packadd vim-filetype-formatter
let g:vim_filetype_formatter_commands['python'] = g:vim_filetype_formatter_builtins['ruff']
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
" https://github.com/hrsh7th/vim-vsnip
let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets')

" }}}
" Autocmds {{{

augroup filetype_assignment
  autocmd!
  autocmd BufRead,BufNewFile,BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf,credentials,.editorconfig set filetype=dosini
  autocmd BufRead,BufNewFile,BufEnter *.config,.cookiecutterrc,DESCRIPTION,.lintr set filetype=yaml
  autocmd BufRead,BufNewFile,BufEnter docker-compose.* set filetype=yaml
  autocmd BufRead,BufNewFile,BufEnter *.mdx set filetype=markdown.mdx
  autocmd BufRead,BufNewFile,BufEnter *.min.js set filetype=none
  autocmd BufRead,BufNewFile,BufEnter *.oct set filetype=octave
  autocmd BufRead,BufNewFile,BufEnter .envrc set filetype=sh
  autocmd BufRead,BufNewFile,BufEnter .dockerignore set filetype=conf
  autocmd BufRead,BufNewFile,BufEnter renv.lock,.jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term,*.htmlhintrc,*.stylelintrc,*.firebaserc set filetype=json
  autocmd BufRead,BufNewFile,BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufRead,BufNewFile,BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
augroup end

augroup filetype_custom
  autocmd!
  autocmd Filetype vim call system(['git', 'clone', 'https://github.com/kristijanhusak/vim-packager', $HOME .. '/.config/nvim/pack/packager/opt/vim-packager'])
        \ | packadd vim-packager
        \ | call packager#setup(function('s:packager_init'), {'window_cmd': 'edit'})
  " indentation
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  autocmd Filetype go,gomod,make,snippets,tsv,votl setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " comments
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
  " keywordprg
  autocmd FileType vim setlocal keywordprg=:help
  " nofoldenable nolist
  autocmd FileType gitcommit,checkhealth setlocal nofoldenable nolist
  " window opening
  autocmd FileType gitcommit if winnr("$") > 1 | wincmd T | endif
  " spell
  autocmd FileType markdown* setlocal spell
  " mappings
  autocmd FileType man,info,help,qf
        \ nnoremap <buffer> d <C-d> |
        \ nnoremap <buffer> D <C-d> |
        \ nnoremap <buffer> u <C-u> |
        \ nnoremap <buffer> U <C-u> |
        \ nnoremap <buffer> q <Cmd>quit<CR>
  autocmd FileType man,info,help
        \ nnoremap <buffer> <C-]> <C-]> |
        \ nnoremap <buffer> <RightMouse> <C-o> |
        \ nnoremap <buffer> <2-RightMouse> <C-o> |
        \ nnoremap <buffer> <3-RightMouse> <C-o> |
        \ nnoremap <buffer> <4-RightMouse> <C-o> |
        \ nmap <buffer> <CR> K
  autocmd FileType qf
        \ nnoremap <buffer> <C-v> <Cmd>call <SID>quickfix_vsplit()<CR> |
        \ nnoremap <buffer> <C-x> <Cmd>call <SID>quickfix_split()<CR> |
        \ nnoremap <buffer> <C-t> <Cmd>call <SID>quickfix_tabedit()<CR>
  autocmd FileType NvimTree
        \ nnoremap <buffer> <C-g> <Cmd>echo substitute(getcwd(), $HOME . '/', '~/', '')<CR>
augroup end

augroup custom_lsp
  autocmd!
  autocmd LspAttach * echom printf('%s (%s): LSP warming up...', expand('%:t'), &filetype)
  autocmd BufReadPre * autocmd DiagnosticChanged * ++once echom printf('%s (%s): LSP ready!', expand('%:t'), &filetype)
augroup end

augroup miscellaneous_custom
  autocmd!
  autocmd BufWinEnter * execute 'setlocal listchars+=leadmultispace:│' .. repeat('\ ', &shiftwidth - 1)
  autocmd BufWritePre * TrimWhitespace
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
  autocmd VimEnter * if exists(':NvimTreeOpen') && len(argv()) == 1 && isdirectory(argv(0)) | execute 'NvimTreeOpen ' .. argv(0) | endif
  " https://github.com/neovim/neovim/issues/20456
  autocmd ColorScheme,VimEnter * highlight! link luaParenError Normal | highlight! link luaError Normal | highlight! link luaTable Normal
augroup end

" }}}
" Mappings {{{

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
nnoremap <Leader>gv <Cmd>edit ~/.config/nvim/init.vim<CR>
nnoremap <Leader>gl <Cmd>edit ~/.config/nvim/lua/packages.lua<CR>
nnoremap <Leader>gz <Cmd>edit ~/.zshrc<CR>
nnoremap <Leader>gb <Cmd>edit ~/.bashrc<CR>
xnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <RightMouse> <LeftMouse>za
nnoremap <2-RightMouse> <LeftMouse>za
nnoremap <3-RightMouse> <LeftMouse>za
nnoremap <4-RightMouse> <LeftMouse>za
nnoremap <C-]> <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <C-k> <Cmd>lua vim.lsp.buf.hover()<CR>
inoremap <C-s> <Cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <Leader>su <Cmd>lua vim.lsp.buf.references()<CR>
nnoremap <Leader>sr <Cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>sa <Cmd>lua vim.lsp.buf.code_action()<CR>
xnoremap <Leader>sa <Cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <Leader>dd <Cmd>lua vim.diagnostic.disable()<CR>
nnoremap <Leader>de <Cmd>lua vim.diagnostic.enable()<CR>
nnoremap ]g <Cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap [g <Cmd>lua vim.diagnostic.goto_prev()<CR>
" https://github.com/hedyhli/outline.nvim
nnoremap <Space>l zR<Cmd>Outline<CR>
" https://github.com/hrsh7th/vim-vsnip
imap <expr> <C-j> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
" https://github.com/pappasam/nvim-repl
nnoremap <Leader>rt <Cmd>ReplToggle<CR>
nmap <silent> <Leader>rc <Plug>ReplSendCell
nmap <silent> <Leader>rr <Plug>ReplSendLine
xmap <silent> <Leader>r <Plug>ReplSendVisual
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
nnoremap <Leader>f <Cmd>FiletypeFormat<CR>
xnoremap <Leader>f :FiletypeFormat<CR>
" https://github.com/kyazdani42/nvim-tree.lua
nnoremap <Space>j <Cmd>NvimTreeFindFileToggle<CR><Cmd>echo substitute(getcwd(), $HOME . '/', '~/', '')<CR>

" }}}
" Commands {{{

command! Fit call s:resize_window_width()
function! s:resize_window_width()
  if &wrap
    echo 'run `:set nowrap` before resizing window'
    return
  endif
  let max_length = max(map(range(1, line('$')), "virtcol([v:val, '$'])"))
  let leading_space = getwininfo(win_getid())[0].textoff
  normal! ma
  execute ':vertical resize ' .. (max_length + leading_space)
  normal! `a
endfunction

command! Focus call s:focuswriting()
function! s:focuswriting()
  normal! ma
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
  normal! `azz
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
  silent! %substitute/”/"/g
  silent! %substitute/“/"/g
  silent! %substitute/’/'/g
  silent! %substitute/‘/'/g
  silent! %substitute/—/-/g
  silent! %substitute/…/.../g
  silent! %substitute/​//g
  call winrestview(save)
endfunction

command! TrimWhitespace call s:trim_whitespace()
function! s:trim_whitespace()
  let save = winsaveview()
  if &filetype ==? 'markdown' " Only trailing, 1 trailing, and 2+ trailing
    silent!              %substitute/^\s\+$//e
    silent! %global/\S\s$/substitute/\s$//g
    silent!              %substitute/\s\s\s\+$/  /e
  else
    silent! %substitute/\s\+$//e
  endif
  call winrestview(save)
endfunction

command! Preview call s:preview()
function! s:preview()
  if &filetype ==? 'markdown' " https://github.com/iamcco/markdown-preview.nvim
    silent! MarkdownPreview
  elseif &filetype ==? 'mermaid'
    let tempfile = printf('/tmp/preview-mermaid-%i.pdf', rand())
    call jobstart(printf("echo '%1$s' | entr -ns 'mmdc --pdfFit -i \'%1$s\' -o %2$s'", expand('%'), tempfile))
    call jobstart(printf('while [ ! -f %1$s ]; do sleep 0.5; done; zathura %1$s', tempfile))
  else
    echohl WarningMsg | echom ':Preview not supported for this filetype' | echohl None
  endif
endfunction

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

" }}}
