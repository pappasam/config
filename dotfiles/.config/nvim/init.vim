" Autocmds {{{
" Placed at top because some events (like ColorScheme) happen in init.vim

augroup filetype_assignment
  autocmd!
  autocmd BufRead,BufNewFile,BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf,credentials,.editorconfig set filetype=dosini
  autocmd BufRead,BufNewFile,BufEnter *.config,.cookiecutterrc,DESCRIPTION,.lintr set filetype=yaml
  autocmd BufRead,BufNewFile,BufEnter docker-compose.* set filetype=yaml
  autocmd BufRead,BufNewFile,BufEnter *.github/workflows/*.yml set filetype=yaml.githubactions
  autocmd BufRead,BufNewFile,BufEnter *.mdx set filetype=markdown.mdx
  autocmd BufRead,BufNewFile,BufEnter *.min.js set filetype=none
  autocmd BufRead,BufNewFile,BufEnter *.oct set filetype=octave
  autocmd BufRead,BufNewFile,BufEnter .envrc,.env,.env.* set filetype=sh
  autocmd BufRead,BufNewFile,BufEnter .dockerignore set filetype=conf
  autocmd BufRead,BufNewFile,BufEnter renv.lock,.jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term,*.htmlhintrc,*.stylelintrc,*.firebaserc set filetype=json
  autocmd BufRead,BufNewFile,BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufRead,BufNewFile,BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
  autocmd BufRead,BufNewFile,BufEnter zathurarc set filetype=zathurarc
augroup end

augroup filetype_custom
  autocmd!
  " indentation
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  autocmd Filetype go,gomod,make,tsv,votl setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " comments
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType mermaid setlocal commentstring=\%\%\ %s comments=:\%\%
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
  " iskeyword
  autocmd FileType nginx setlocal iskeyword+=$
  autocmd FileType toml,zsh,sh,bash,css setlocal iskeyword+=-
  autocmd FileType scss setlocal iskeyword+=@-@
  " keywordprg
  autocmd FileType vim setlocal keywordprg=:help
  " nofoldenable nolist
  autocmd FileType gitcommit,checkhealth setlocal nofoldenable nolist
  " window opening
  autocmd FileType gitcommit if winnr("$") > 1 | wincmd T | endif
  " disable gitsigns
  autocmd FileType xxd DisableNoisyPlugins
augroup end

augroup miscellaneous_custom
  autocmd!
  autocmd BufWritePre * TrimWhitespace
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
  autocmd VimEnter * call packager#setup(function('s:packager_init'), {'window_cmd': 'edit'})
  autocmd InsertEnter * setlocal listchars=tab:>\ ,lead:\ ,nbsp:+
  autocmd InsertLeave * setlocal listchars=tab:>\ ,lead:\ ,nbsp:+,trail:-
augroup end

" }}}
" Packages {{{

lua require('packages') -- ~/.config/nvim/lua/packages.lua

function! s:packager_init(p) abort
  call a:p.add('https://github.com/kristijanhusak/vim-packager')
  " Language Server (LSP)
  call a:p.add('https://github.com/neovim/nvim-lspconfig')
  call a:p.add('https://github.com/stevearc/aerial.nvim')
  call a:p.add('https://github.com/j-hui/fidget.nvim.git')
  " Autocompletion
  call a:p.add('https://github.com/Saghen/blink.cmp', {'do': 'cargo build --release'})
  " Tree Sitter
  call a:p.add('https://github.com/nvim-treesitter/nvim-treesitter')
  call a:p.add('https://github.com/windwp/nvim-ts-autotag')
  " Tree
  call a:p.add('https://github.com/nvim-tree/nvim-tree.lua')
  call a:p.add('https://github.com/nvim-tree/nvim-web-devicons')
  " Fuzzy Finder
  call a:p.add('https://github.com/nvim-telescope/telescope.nvim')
  call a:p.add('https://github.com/nvim-lua/plenary.nvim')
  " Git
  call a:p.add('https://github.com/tpope/vim-fugitive')
  call a:p.add('https://github.com/lewis6991/gitsigns.nvim')
  " Miscellaneous
  call a:p.add('https://github.com/pappasam/papercolor-theme-slim')
  call a:p.add('https://github.com/sotte/presenting.nvim.git')
  call a:p.add('https://github.com/lukas-reineke/indent-blankline.nvim.git')
  call a:p.add('https://github.com/HiPhish/jinja.vim')
  call a:p.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:p.add('https://github.com/fidian/hexmode')
  call a:p.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})
  call a:p.add('https://github.com/pappasam/nvim-repl')
  call a:p.add('https://github.com/pappasam/vim-filetype-formatter')
  call a:p.add('https://github.com/windwp/nvim-autopairs')
  call a:p.add('https://github.com/machakann/vim-sandwich')
  call a:p.add('https://github.com/HiPhish/info.vim')
  call a:p.add('https://github.com/chrishrb/gx.nvim')
endfunction

call system(['git', 'clone', 'https://github.com/kristijanhusak/vim-packager', expand('~/.config/nvim/pack/packager/start/vim-packager')])

" }}}
" Settings {{{

aunmenu PopUp.-1-
aunmenu PopUp.How-to\ disable\ mouse
lua require('options') -- ~/.config/nvim/lua/options.lua
colorscheme PaperColorSlim
digraph '' 699  " Hawaiian character ʻ
set cmdheight=2
set completeopt=menuone,longest,fuzzy wildmode=longest:full
set cursorline cursorlineopt=number
set diffopt+=internal,algorithm:patience
set expandtab shiftwidth=2 softtabstop=2
set exrc
set foldmethod=marker foldnestmax=1 foldcolumn=auto
set grepprg=rg\ --vimgrep
set history=10
set isfname+=@-@,:
set list listchars=tab:>\ ,lead:\ ,nbsp:+,trail:-
set mouse=a
set noshowcmd
set noshowmode
set noswapfile
set notimeout
set nowrap linebreak breakat=\ \	,])/-
set number
set path+=/usr/include/x86_64-linux-gnu/
set shadafile=NONE
set shortmess+=cI
set showtabline=2
set signcolumn=number
set nospell spelllang=en_us
set splitright
set termguicolors
set updatetime=300
set statusline=\ %t%R%M%H%W
let $PATH = $PWD .. '/node_modules/.bin:' .. $PATH
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
      \ 'haskell': 'ghci',
      \ 'python': 'ipython --quiet --no-autoindent -i -c "%config InteractiveShell.ast_node_interactivity=\"last_expr_or_assign\""',
      \ 'r': 'R',
      \ 'sh': 'sh',
      \ 'vim': 'nvim --clean -ERM',
      \ 'zsh': 'zsh',
      \ }
let g:repl_default = &shell
" https://github.com/iamcco/markdown-preview.nvim
let g:mkdp_preview_options = {'disable_sync_scroll': 0, 'sync_scroll_type': 'middle'}

" }}}
" Mappings {{{

let g:mapleader = ','
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
nnoremap gx <Cmd>Browse<CR>
xnoremap gx <Cmd>Browse<CR>
nnoremap <Leader>ga <Cmd>edit ~/.config/alacritty/alacritty.toml<CR>
nnoremap <Leader>gv <Cmd>edit ~/.config/nvim/init.vim<CR>
nnoremap <Leader>gl <Cmd>edit ~/.config/nvim/lua/packages.lua<CR>
nnoremap <Leader>gt <Cmd>edit ~/.config/tmux/tmux.conf<CR>
nnoremap <Leader>gz <Cmd>edit ~/.zshrc<CR>
nnoremap <Leader>gb <Cmd>edit ~/.bashrc<CR>
xnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <expr> za line('.') == 1 ? 'za' : 'kjza'
" help lsp-defaults
nnoremap <Leader>d <Cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>
nnoremap <C-k> <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap grd <Cmd>lua vim.diagnostic.open_float()<CR>
" https://github.com/stevearc/aerial.nvim
nnoremap <Space>l zR<Cmd>AerialToggle<CR>
" https://github.com/pappasam/nvim-repl
nnoremap <Leader>rt <Cmd>ReplToggle<CR>
nmap <silent> <Leader>rc <Plug>ReplSendCell
nmap <silent> <Leader>rr <Plug>ReplSendLine
xmap <silent> <Leader>r <Plug>ReplSendVisual
" https://github.com/machakann/vim-sandwich
nmap s <Nop>
xmap s <Nop>
" https://github.com/nvim-telescope/telescope.nvim
nnoremap <C-p><C-b> <Cmd>Telescope buffers<CR>
nnoremap <C-p><C-d> <Cmd>Telescope diagnostics<CR>
nnoremap <C-p><C-g> <Cmd>Telescope git_commits<CR>
nnoremap <C-p><C-h> <Cmd>Telescope help_tags<CR>
nnoremap <C-p><C-p> <Cmd>Telescope find_files hidden=true<CR>
nnoremap <C-p><C-s> <Cmd>Telescope live_grep<CR>
nnoremap <C-p><C-w> <Cmd>Telescope grep_string<CR>
nnoremap z= <Cmd>Telescope spell_suggest<CR>
" https://github.com/pappasam/vim-filetype-formatter
nnoremap <Leader>f <Cmd>FiletypeFormat<CR>
xnoremap <Leader>f :FiletypeFormat<CR>
" https://github.com/kyazdani42/nvim-tree.lua
nnoremap <Space>j <Cmd>NvimTreeFindFileToggle<CR>
" FileType-specific mappings
augroup filetype_remap
  autocmd FileType man,info,help,qf
        \ nnoremap <buffer> d <C-d>|
        \ nnoremap <buffer> D <C-d>|
        \ nnoremap <buffer> u <C-u>|
        \ nnoremap <buffer> U <C-u>|
        \ nnoremap <buffer> q <Cmd>quit<CR>
  autocmd FileType qf
        \ nnoremap <buffer> <C-v> <Cmd>call <SID>quickfix_vsplit()<CR>|
        \ nnoremap <buffer> <C-x> <Cmd>call <SID>quickfix_split()<CR>|
        \ nnoremap <buffer> <C-t> <Cmd>call <SID>quickfix_tabedit()<CR>
augroup end

" }}}
" Commands {{{

command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! W w
command! Wa wa
command! WA wa
command! Wq wq
command! WQ wq
command! Wqa wqa
command! WQa wqa
command! WQA wqa
command! Gm Git commit
command! Gmv Git commit --verbose
command! Gma Git add . | Git commit
command! Gmav Git add . | Git commit --verbose
command! BackgroundToggle !togglebackground

command! ConcealToggle call s:toggle_conceal()
function! s:toggle_conceal()
  if !exists('w:custom_toggle_conceal') || w:custom_toggle_conceal == 0
    set conceallevel=3 concealcursor=nc
    let w:custom_toggle_conceal = 1
  else
    set conceallevel=0 concealcursor=
    let w:custom_toggle_conceal = 0
  endif
endfunction

command! DisableNoisyPlugins call s:disable_noisy_plugins()
function! s:disable_noisy_plugins()
  lua vim.diagnostic.enable(false)
  Gitsigns detach
  Fidget suppress
endfunction

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

command! F call s:focuswriting()
function! s:focuswriting()
  if exists('t:focuswriting')
    tabclose
    return
  endif
  normal! ma
  let current_buffer = bufnr('%')
  tabe
  let t:focuswriting = 1
  " Left Window
  setlocal readonly nobuflisted nonumber norelativenumber fillchars=eob:\  statusline=\  colorcolumn=0 winhighlight=Normal:NormalFloat
  vsplit
  vsplit
  " Right Window
  setlocal readonly nobuflisted nonumber norelativenumber fillchars=eob:\  statusline=\  colorcolumn=0 winhighlight=Normal:NormalFloat
  wincmd h
  " Middle Window
  vertical resize 88
  execute 'buffer ' .. current_buffer
  setlocal number norelativenumber wrap winfixwidth colorcolumn=0 nofoldenable
  ConcealToggle
  wincmd =
  normal! `azz
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
