" Usage: toggle fold in Vim with 'za'. 'zR' to open all folds, 'zM' to close
" General: package management {{{

" Automatically install nvim-packager
call system([
      \ 'git',
      \ 'clone',
      \ 'https://github.com/kristijanhusak/vim-packager',
      \ $HOME . '/.config/nvim/pack/packager/opt/vim-packager'])

" Available Commands:
"   PackagerStatus, PackagerInstall, PackagerUpdate, PackagerClean

function! s:packager_init(packager) abort
  call a:packager.add('https://github.com/kristijanhusak/vim-packager', {'type': 'opt'})

  " Autocompletion And IDE Features:
  call a:packager.add('https://github.com/neoclide/coc.nvim.git', {'do': 'yarn install --frozen-lockfile'})
  call a:packager.add('https://github.com/pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' })

  " TreeSitter:
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter.git', {'do': ':TSUpdate'})
  call a:packager.add('https://github.com/nvim-treesitter/playground.git')
  call a:packager.add('https://github.com/windwp/nvim-ts-autotag.git')
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter-context')
  call a:packager.add('https://github.com/JoosepAlviste/nvim-ts-context-commentstring.git', {'requires': [
      \ 'https://github.com/tpope/vim-commentary',
      \ ]})

  " Editorconfig:
  call a:packager.add('https://github.com/gpanders/editorconfig.nvim.git')

  " Tree:
  call a:packager.add('https://github.com/kyazdani42/nvim-tree.lua.git', {'requires': [
      \ 'https://github.com/kyazdani42/nvim-web-devicons.git',
      \ ]})

  " General:
  call a:packager.add('https://github.com/fidian/hexmode')
  call a:packager.add('https://github.com/simeji/winresizer')
  call a:packager.add('https://github.com/sjl/strftimedammit.vim')
  call a:packager.add('https://github.com/windwp/nvim-autopairs.git')
  call a:packager.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:packager.add('https://github.com/tpope/vim-characterize.git')

  " KeywordPrg:
  call a:packager.add('https://github.com/pappasam/vim-keywordprg-commands.git')

  " Fuzzy Finder:
  call a:packager.add('https://github.com/nvim-telescope/telescope.nvim.git', {'requires': [
      \ 'https://github.com/nvim-lua/plenary.nvim.git',
      \ ]})

  " Git:
  call a:packager.add('https://github.com/tpope/vim-fugitive')
  call a:packager.add('https://github.com/lewis6991/gitsigns.nvim.git')

  " Text Objects:
  call a:packager.add('https://github.com/machakann/vim-sandwich')
  call a:packager.add('https://github.com/kana/vim-textobj-user')

  " Writing:
  call a:packager.add('https://github.com/jlesquembre/rst-tables.nvim')
  call a:packager.add('https://github.com/moiatgit/vim-rst-sections')

  " Previewers:
  call a:packager.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})

  " Code Formatters:
  call a:packager.add('https://github.com/pappasam/vim-filetype-formatter')

  " Repl Integration:
  call a:packager.add('https://github.com/pappasam/nvim-repl.git', {'requires': [
        \ 'https://github.com/tpope/vim-repeat',
        \ ]})

  " Syntax Theme:
  call a:packager.add('https://github.com/pappasam/papercolor-theme-slim.git')

  " Syntax Highlighting & Indentation:
  call a:packager.add('https://github.com/evanleck/vim-svelte.git', {'requires': [
      \ 'https://github.com/cakebaker/scss-syntax.vim.git',
      \ 'https://github.com/groenewege/vim-less.git',
      \ 'https://github.com/leafgarland/typescript-vim.git',
      \ 'https://github.com/othree/html5.vim.git',
      \ 'https://github.com/pangloss/vim-javascript.git',
      \ ]})
  call a:packager.add('https://github.com/Vimjas/vim-python-pep8-indent')
  call a:packager.add('https://github.com/osohq/polar.vim')
  call a:packager.add('https://github.com/Yggdroot/indentLine')
  call a:packager.add('https://github.com/aklt/plantuml-syntax.git')
  call a:packager.add('https://github.com/chr4/nginx.vim.git')
  call a:packager.add('https://github.com/delphinus/vim-firestore.git')
  call a:packager.add('https://github.com/mattn/vim-xxdcursor')
  call a:packager.add('https://github.com/neovimhaskell/haskell-vim')
  call a:packager.add('https://github.com/raimon49/requirements.txt.vim.git')
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'), {
      \ 'window_cmd': 'edit',
      \ })

" }}}
" General: environment variables {{{

" Path: add node_modules for language servers / linters / other stuff
let $PATH = $PWD . '/node_modules/.bin:' . $PATH

" }}}
" General: options {{{

" Enable filetype detection, plugin loading, and indentation loading
filetype plugin indent on

" Code Completion:
set completeopt=menuone,longest wildmode=longest:full wildmenu

" Messages:
" c = don't give |ins-completion-menu| messages; they're noisy
" I = ignore startup message
set shortmess+=c shortmess+=I

" Hidden Buffer: enable instead of having to write each buffer
set hidden

" Sign Column: always show it
set signcolumn=number

set cursorline

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set noswapfile

" Command Line Height: higher for display for messages
set cmdheight=2

" Line Wrapping: do not wrap lines by default
set nowrap linebreak

" Indentation:
set expandtab autoindent smartindent shiftwidth=2 softtabstop=2 tabstop=8

" Filename: for gf (@-@='@', see: https://stackoverflow.com/a/45244758)
set isfname+=@-@ isfname+=:

" Highlight Search: do that
" note: hlsearcha nd nohlsearch are defined in autocmd outside function
set incsearch inccommand=nosplit

" Spell Checking:
set dictionary=$HOME/config/docs/dict/american-english-with-propcase.txt
set spelllang=en_us

" Single Space After Punctuation: useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

set autoread

set grepprg=rg\ --vimgrep

" Don't timeout on mappings
set notimeout

" Numbering:
set number

" Window Splitting: Set split settings (options: splitright, splitbelow)
set splitright

" Terminal Color Support: only set guicursor if truecolor
if $COLORTERM ==# 'truecolor'
  set termguicolors
else
  set guicursor=
endif

" Set Background: defaults to dark
set background=dark

" Colorcolumn: off by default
set colorcolumn=

" Status Line: specifics for custom status line
set laststatus=2 ttimeoutlen=50 noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" Updatetime: time Vim waits to do something after I stop moving
set updatetime=300

" Linux Dev Path: system libraries
set path+=/usr/include/x86_64-linux-gnu/

" Vim History: for command line
set history=10

" Set the diff expression to EnhancedDiff
set diffopt+=internal,algorithm:patience

" Show :list characters, configure with a nice default
set list
set listchars=tab:>\ ,nbsp:+,leadmultispace:\ ,multispace:-

" Folding
set foldenable foldmethod=marker foldnestmax=1

" }}}
" General: statusline {{{

" Status Line
set laststatus=2
set statusline=
set statusline+=%#CursorLine#
set statusline+=\ %{mode()}
set statusline+=\ %*\  " Color separator + space
set statusline+=%{&paste?'[P]':''}
set statusline+=%{&spell?'[S]':''}
set statusline+=%r
set statusline+=%t
set statusline+=%m
set statusline+=%=
set statusline+=\ %v:%l/%L\  " column, line number, total lines
set statusline+=\ %y\  " file type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding

" Status Line
augroup statusline_overrides
  autocmd!
  autocmd BufEnter NvimTree* setlocal statusline=\ NvimTree\ %#CursorLine#
augroup end

" }}}
" General: tabline {{{

function! CustomTabLine()
  " Initialize tabline string
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'
    " the label is made by MyTabLabel()
    let s ..= ' ' . (i + 1) . ':%{CustomTabLabel(' .. (i + 1) .. ')} '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s ..= '%=%#TabLine#%999X ✗ '
  endif
  return s
endfunction

function! CustomTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let postfix = ''
  for buf in buflist
    if bufname(buf) == 'focuswriting_abcdefg'
      let postfix = '🎯'
      break
    endif
  endfor
  let bname = bufname(buflist[winnr - 1])
  let bnamemodified = fnamemodify(bname, ':t')
  if bnamemodified == ''
    " No name
    return '👻' . postfix
  elseif bnamemodified =~ 'NvimTree'
    return '🌲' . postfix
  else
    return bnamemodified . postfix
  endif
endfunction

set tabline=%!CustomTabLine()

" }}}
" General: autocmds {{{

augroup redraw_on_refocus
  autocmd!
  autocmd FocusGained * redraw!
augroup end

augroup vim_resized
  autocmd!
  autocmd VimResized * wincmd =
augroup end

augroup incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup end

augroup filetype_assignment
  autocmd!
  autocmd BufEnter *.asm set filetype=nasm
  autocmd BufEnter *.scm set filetype=query
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf,config,credentials set filetype=dosini
  autocmd BufEnter *.config,.cookiecutterrc,DESCRIPTION,.lintr set filetype=yaml
  autocmd BufEnter *.handlebars set filetype=html
  autocmd BufEnter *.hql,*.q set filetype=hive
  autocmd BufEnter *.js,*.gs set filetype=javascript
  autocmd BufEnter *.mdx set filetype=markdown
  autocmd BufEnter *.min.js set filetype=none
  autocmd BufEnter *.m,*.oct set filetype=octave
  autocmd BufEnter *.toml set filetype=toml
  autocmd BufEnter *.tsv set filetype=tsv
  autocmd BufEnter .envrc set filetype=sh
  autocmd BufEnter .gitignore,.dockerignore set filetype=conf
  autocmd BufEnter renv.lock,.jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term,*.htmlhintrc,*.stylelintrc,*.firebaserc set filetype=json
  autocmd BufEnter Dockerfile.* set filetype=dockerfile
  autocmd BufEnter Makefile.* set filetype=make
  autocmd BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
  autocmd BufEnter tmux-light.conf set filetype=tmux
  autocmd BufEnter .zshrc set filetype=zsh
augroup end

augroup indentation_overrides
  autocmd!
  " Reset to 2 (something somewhere overrides...)
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  " 4 spaces per tab, not 2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3
        \ setlocal shiftwidth=4 softtabstop=4
  " Use hard tabs, not spaces
  autocmd Filetype make,tsv,votl,go,gomod
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
  " Fix weird stuff with snippet indentation
  autocmd Filetype snippets setlocal tabstop=4 softtabstop=0 shiftwidth=0
        \ noexpandtab noautoindent nosmartindent
augroup end

augroup comment_config
  " Notes:
  " commentstring: read by vim-commentary; must be one template
  " comments: csv of comments.
  " formatoptions: influences how Vim formats text
  "   ':help fo-table' will get the desired result
  autocmd!
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType mermaid setlocal commentstring=\%\%\ %s comments=:\%\%
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
augroup end

augroup keyword_overrides
  autocmd!
  autocmd FileType nginx set iskeyword+=$
  autocmd FileType zsh,sh set iskeyword+=-
augroup end

augroup keywordprg_overiddes
  autocmd!
  autocmd FileType markdown setlocal keywordprg=:DefEng
augroup end

augroup fold_overrides
  autocmd!
  " Warning: operates at the window level, so be careful with this setting
  autocmd FileType gitcommit setlocal nofoldenable
augroup end

augroup commit_newtab
  autocmd!
  autocmd FileType gitcommit
        \ if winnr("$") > 1 |
        \ wincmd T |
        \ endif
augroup end

" }}}
" General: key mappings (global and filetype-specific) {{{

let mapleader = ','

function! s:default_key_mappings()
  " Coc: settings for coc.nvim
  nmap     <silent>        <C-]> <Plug>(coc-definition)
  nnoremap <silent>        <C-k> <Cmd>call CocActionAsync('doHover')<CR>
  inoremap <silent>        <C-s> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
  nnoremap <silent>        <C-w>f <Cmd>call coc#float#jump()<CR>
  nmap     <silent>        <leader>st <Plug>(coc-type-definition)
  nmap     <silent>        <leader>si <Plug>(coc-implementation)
  nmap     <silent>        <leader>su <Plug>(coc-references)
  nmap     <silent>        <leader>sr <Plug>(coc-rename)
  nmap     <silent>        <leader>sa v<Plug>(coc-codeaction-selected)
  vmap     <silent>        <leader>sa <Plug>(coc-codeaction-selected)
  nnoremap <silent>        <leader>sh <Cmd>call CocActionAsync('highlight')<CR>
  nnoremap <silent>        <leader>sn <Cmd>CocNext<CR>
  nnoremap <silent>        <leader>sp <Cmd>CocPrev<CR>
  nnoremap <silent>        <leader>sl <Cmd>CocListResume<CR>
  nnoremap <silent>        <leader>sc <Cmd>CocList commands<cr>
  nnoremap <silent>        <leader>so <Cmd>CocList -A outline<cr>
  nnoremap <silent>        <leader>sw <Cmd>CocList -A -I symbols<cr>
  inoremap <silent> <expr> <c-space> coc#refresh()
  nnoremap                 <leader>d <Cmd>call CocActionAsync('diagnosticToggleBuffer')<CR>
  nnoremap                 <leader>D <Cmd>call CocActionAsync('diagnosticPreview')<CR>
  nmap     <silent>        ]g <Plug>(coc-diagnostic-next)
  nmap     <silent>        [g <Plug>(coc-diagnostic-prev)

  " Toggle gitsigns
  nnoremap <silent> <leader>g <Cmd>GitsignsToggle<CR>

  " View Syntax Groups
  nnoremap <silent> zS <cmd>call <SID>syntax_group()<CR>

  " J: unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " SearchBackward: remap comma to single quote
  nnoremap ' ,

  " Exit: Preview, Help, QuickFix, and Location List
  inoremap <silent> <C-c> <Esc>:pclose <BAR> cclose <BAR> lclose <CR>a
  nnoremap <silent> <C-c> :pclose <BAR> cclose <BAR> lclose <CR>

  " MoveVisual: up and down visually only if count is specified before
  nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j v:count == 0 ? 'gj' : 'j'

  " Macro Repeater:
  " Enable calling a function within the mapping for @
  nnoremap <expr> <plug>@init AtInit()
  " A macro could, albeit unusually, end in Insert mode.
  inoremap <expr> <plug>@init "\<c-o>".AtInit()
  nnoremap <expr> <plug>qstop QStop()
  inoremap <expr> <plug>qstop "\<c-o>".QStop()
  " The following code allows pressing . immediately after
  " recording a macro to play it back.
  nmap <expr> @ AtReg()
  " Finally, remap q! Recursion is actually useful here I think,
  " otherwise I would use 'nnoremap'.
  nmap <expr> q QStart()

  " MoveTabs: goto tab number. Same as Firefox
  nnoremap <silent> <A-1> <Cmd>silent! 1tabnext<CR>
  nnoremap <silent> <A-2> <Cmd>silent! 2tabnext<CR>
  nnoremap <silent> <A-3> <Cmd>silent! 3tabnext<CR>
  nnoremap <silent> <A-4> <Cmd>silent! 4tabnext<CR>
  nnoremap <silent> <A-5> <Cmd>silent! 5tabnext<CR>
  nnoremap <silent> <A-6> <Cmd>silent! 6tabnext<CR>
  nnoremap <silent> <A-7> <Cmd>silent! 7tabnext<CR>
  nnoremap <silent> <A-8> <Cmd>silent! 8tabnext<CR>
  nnoremap <silent> <A-9> <Cmd>silent! $tabnext<CR>

  " ToggleRelativeNumber: uses custom functions
  nnoremap <silent> <leader>R <Cmd>ToggleNumber<CR>
  nnoremap <silent> <leader>r <Cmd>ToggleRelativeNumber<CR>

  " TogglePluginWindows:
  nnoremap <silent> <space>j <Cmd>NvimTreeFindFileToggle<CR>
  nnoremap <silent> <space>l <Cmd>call <SID>coc_toggle_outline()<CR>

  " Writing:
  nnoremap <leader><leader>g <Cmd>FocusWriting<CR>

  " IndentLines: toggle if indent lines is visible
  nnoremap <silent> <leader>i <Cmd>IndentLinesToggle<CR>

  " ResizeWindow: up and down; relies on custom functions
  nnoremap <silent> <leader><leader>h <Cmd>ResizeWindowHeight<CR>
  nnoremap <silent> <leader><leader>w <Cmd>ResizeWindowWidth<CR>

  " Repl: my very own repl plugin
  nnoremap <leader><leader>e <Cmd>ReplToggle<CR>
  nmap     <leader>e         <Plug>ReplSendLine
  vmap     <leader>e         <Plug>ReplSendVisual

  " Sandwich: plugin-recommended mappings
  nmap s <Nop>
  xmap s <Nop>

  " Telescope: create shortcuts for finding stuff
  nnoremap <silent> <C-p><C-p> <Cmd>Telescope find_files hidden=true<CR>
  nnoremap <silent> <C-p><C-b> <Cmd>Telescope buffers<CR>
  nnoremap <silent> <C-p><C-g> <Cmd>Telescope git_status<CR>
  nnoremap <silent> <C-n><C-n> <Cmd>Telescope live_grep<CR>
  nnoremap <silent> <C-n><C-w> <Cmd>Telescope grep_string<CR>
  nnoremap <silent> <C-n><C-h> <Cmd>Telescope help_tags<CR>

  " FiletypeFormat: remap leader f to do filetype formatting
  nnoremap <silent> <leader>f <Cmd>silent! CocDisable<cr><Cmd>FiletypeFormat<cr><Cmd>silent! CocEnable<cr>
  vnoremap <silent> <leader>f <Cmd>silent! CocDisable<cr>:FiletypeFormat<cr><Cmd>silent! CocEnable<cr>

  " Open <cfile> with gx
  nnoremap gx <Cmd>call <SID>gx_improved()<CR>

  " Clipboard Copy: Visual mode copy is pretty simple
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y

  " Mouse: toggle folds with middle click (I never use it for paste)
  noremap <silent> <MiddleMouse>   <LeftMouse>za
  noremap <silent> <2-MiddleMouse> <LeftMouse>za
  noremap <silent> <3-MiddleMouse> <LeftMouse>za
  noremap <silent> <4-MiddleMouse> <LeftMouse>za

  " Auto-execute all filetypes
  let &filetype=&filetype
endfunction

call s:default_key_mappings()

augroup remap_man_help
  autocmd!
  autocmd FileType man,help nnoremap <buffer> <silent> <C-]> <C-]>
augroup end

function! s:mappings_rst()
  nnoremap <buffer>          <leader>f <Cmd>TableRstFormat<CR>
  nnoremap <buffer> <silent> <leader>s0 <Cmd>call RstSetSection(0)<CR>
  nnoremap <buffer> <silent> <leader>s1 <Cmd>call RstSetSection(1)<CR>
  nnoremap <buffer> <silent> <leader>s2 <Cmd>call RstSetSection(2)<CR>
  nnoremap <buffer> <silent> <leader>s3 <Cmd>call RstSetSection(3)<CR>
  nnoremap <buffer> <silent> <leader>s4 <Cmd>call RstSetSection(4)<CR>
  nnoremap <buffer> <silent> <leader>s5 <Cmd>call RstSetSection(5)<CR>
  nnoremap <buffer> <silent> <leader>s6 <Cmd>call RstSetSection(6)<CR>
  nnoremap <buffer> <silent> <leader>sk <Cmd>call RstGoPrevSection()<CR>
  nnoremap <buffer> <silent> <leader>sj <Cmd>call RstGoNextSection()<CR>
  nnoremap <buffer> <silent> <leader>sa <Cmd>call RstIncrSectionLevel()<CR>
  nnoremap <buffer> <silent> <leader>sx <Cmd>call RstDecrSectionLevel()<CR>
  nnoremap <buffer> <silent> <leader>sl <Cmd>call RstSectionLabelize()<CR>
endfunction

augroup remap_rst
  autocmd!
  autocmd FileType rst call s:mappings_rst()
augroup end

augroup remap_lsp_format
  autocmd!
  autocmd FileType haskell nmap <buffer> <silent> <leader>f <Cmd>call CocAction('format')<CR>
augroup end

function! s:mappings_nvim_tree_lua()
  nnoremap <buffer> <silent> <C-l> <Cmd>NvimTreeResize +2<CR>
  nnoremap <buffer> <silent> <C-h> <Cmd>NvimTreeResize -2<CR>
endfunction

augroup remap_nvim_tree_lua
  autocmd!
  autocmd FileType NvimTree call s:mappings_nvim_tree_lua()
augroup end

" }}}
" Package: lsp with coc.nvim {{{

let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
let g:coc_start_at_startup = 1
let g:coc_filetype_map = {
      \ 'markdown.mdx': 'markdown',
      \ 'yaml.ansible': 'yaml',
      \ 'yaml.docker-compose': 'yaml',
      \ 'jinja.html': 'html',
      \ }

" Coc Global Extensions: automatically installed on Vim open
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

" Note: coc-angular requires `npm install @angular/language-service` in
" project directory to stop coc from crashing. See:
" <https://github.com/iamcco/coc-angular/issues/47>

function! s:autocmd_custom_coc()
  if !exists("g:did_coc_loaded")
    return
  endif
  augroup coc_custom
    autocmd FileType coctree set nowrap
    autocmd FileType nginx let b:coc_additional_keywords = ['$']
    autocmd FileType scss let b:coc_additional_keywords = ['@']
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd User CocNvimInit call s:default_key_mappings()
  augroup end
endfunction

function! s:coc_toggle_outline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

augroup coc_custom
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_coc()
augroup end

" }}}
" Package: lua extensions {{{

function! s:safe_require(package)
  try
    execute "lua require('" . a:package . "')"
  catch
    echom "Error with lua require('" . a:package . "')"
  endtry
endfunction

function! s:setup_lua_packages()
  call s:safe_require('config/colorizer')
  call s:safe_require('config/gitsigns')
  call s:safe_require('config/nvim-autopairs')
  call s:safe_require('config/nvim-tree')
  call s:safe_require('config/nvim-treesitter')
  call s:safe_require('config/nvim-ts-context-commentstring')
  call s:safe_require('config/nvim-web-devicons')
  call s:safe_require('config/telescope')
  call s:safe_require('config/treesitter-context')
endfunction

call s:setup_lua_packages()

function! s:nvimtree_vimenter()
  let cliargs = argv()
  if exists(':NvimTreeOpen') && len(cliargs) == 1 && isdirectory(cliargs[0])
    execute 'NvimTreeOpen ' . cliargs[0]
  endif
endfunction

augroup lua_extension_config
  autocmd!
  autocmd FileType vim
        \ let &l:path .= ','.stdpath('config').'/lua' |
        \ setlocal suffixesadd^=.lua
  autocmd VimEnter * call s:nvimtree_vimenter()
augroup end

command! GitsignsToggle Gitsigns toggle_signs

" }}}
" General: syntax & colorscheme {{{

function! s:vim_syntax_group()
  let l:s = synID(line('.'), col('.'), 1)
  if l:s == ''
    echo 'none'
  else
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
  endif
endfun

function! s:syntax_group()
  if &syntax == ''
    TSHighlightCapturesUnderCursor
  else
    call s:vim_syntax_group()
  endif
endfunction

augroup colorscheme_overrides
  autocmd!
  autocmd ColorScheme *
        \ highlight link HighlightedyankRegion Search |
        \ highlight link CocHighlightText Underlined |
        \ highlight CocErrorHighlight gui=undercurl |
        \ highlight CocWarningHighlight gui=undercurl |
        \ highlight CocInfoHighlight gui=undercurl |
        \ highlight CocHintHighlight gui=undercurl
  autocmd ColorScheme PaperColorSlim
        \ if &background == 'light' |
        \   execute 'highlight CocSearch guifg=#005f87' |
        \   execute 'highlight CocMenuSel guibg=#bcbcbc' |
        \ else |
        \   execute 'highlight CocSearch guifg=#5fafd7' |
        \   execute 'highlight CocMenuSel guibg=#585858' |
        \ endif
augroup end

try
  colorscheme PaperColorSlim
catch
  echo 'An error occurred while configuring Papercolor'
endtry

" }}}
" General: abbreviations {{{

" If in_command is at beginning of line : return out_command
" Else : return in_command.
function! s:abbr_help(in_command, out_command)
  if (getcmdtype() == ':' && getcmdline() =~ '^' . a:in_command . '$')
    return a:out_command
  else
    return a:in_command
  endif
endfunction

" Open configuration files
cnoreabbrev <expr> v   <SID>abbr_help('v',   'edit ~/.config/nvim/init.vim')
cnoreabbrev <expr> coc <SID>abbr_help('coc', 'edit ~/.config/nvim/coc-settings.json')
cnoreabbrev <expr> z   <SID>abbr_help('z',   'edit ~/.zshrc')
cnoreabbrev <expr> b   <SID>abbr_help('b',   'edit ~/.bashrc')

" Edit snippet files
cnoreabbrev <expr> snip <SID>abbr_help('snip', 'CocCommand snippets.editSnippets')

" 'c' is abbreviation for 'close'. I use it way more often than 'change'
cnoreabbrev <expr> c <SID>abbr_help('c', 'close')

" 'help' to open in new tab
cnoreabbrev <expr> h <SID>abbr_help('h', 'tab help')

" }}}
" General: gx improved {{{

function! s:gx_improved()
  silent execute '!firefox ' . fnameescape(expand('<cfile>'))
endfunction

" }}}
" General: digraphs {{{

digraph '' 699  " Hawaiian character ʻ

" }}}
" General: trailing whitespace {{{

function! s:trim_whitespace()
  let l:save = winsaveview()
  if &ft == 'markdown'
    " Replace lines with only trailing spaces
    silent! execute '%s/^\s\+$//e'
    " Replace lines with exactly one trailing space with no trailing spaces
    silent! execute '%g/\S\s$/s/\s$//g'
    " Replace lines with more than 2 trailing spaces with 2 trailing spaces
    silent! execute '%s/\s\s\s\+$/  /e'
  else
    " Remove all trailing spaces
    silent! execute '%s/\s\+$//e'
  endif
  call winrestview(l:save)
endfunction

command! TrimWhitespace call s:trim_whitespace()

augroup fix_whitespace_on_save
  autocmd!
  autocmd BufWritePre * TrimWhitespace
augroup end

" }}}
" General: window resizing / manipulation functions {{{

" WindowWidth: Resize window to a couple more than longest line
" modified function from:
" https://stackoverflow.com/questions/2075276/longest-line-in-vim
function! s:resize_window_width()
  if &wrap
    echo 'run `:set nowrap` before resizing window'
    return
  endif
  let max_line = line('$')
  let maxlength = max(map(range(1, max_line), "virtcol([v:val, '$'])"))
  let adjustment = &number
        \ ? maxlength + max([len(max_line + ''), 2]) + 1
        \ : maxlength - 1
  normal! m`
  execute ':vertical resize ' . adjustment
  normal! ``
endfunction

function! s:resize_window_height()
  normal! m`
  let initial = winnr()

  " this duplicates code but avoids polluting global namespace
  wincmd k
  if winnr() != initial
    execute initial . 'wincmd w'
    1
    execute 'resize ' . (line('$') + 1)
    normal! ``
    return
  endif

  wincmd j
  if winnr() != initial
    execute initial . 'wincmd w'
    1
    execute 'resize ' . (line('$') + 1)
    normal! ``
    return
  endif
endfunction

command! ResizeWindowWidth call s:resize_window_width()
command! ResizeWindowHeight call s:resize_window_height()

" }}}
" General: focus writing {{{

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
  execute 'buffer ' . current_buffer
  call s:focuswriting_settings_middle()
  wincmd =
  augroup focuswriting
    autocmd!
    autocmd WinEnter focuswriting_abcdefg call s:focuswriting_autocmd()
  augroup end
endfunction

function! s:focuswriting_settings_side()
  setlocal nonumber norelativenumber nocursorline
        \ fillchars=vert:\ ,eob:\  statusline=\  colorcolumn=0
        \ winhighlight=Normal:NormalFloat
endfunction

function! s:focuswriting_settings_middle()
  " Note: stlnc uses <C-k>NS to enter a space character in statusline
  setlocal number norelativenumber wrap nocursorline winfixwidth
        \ fillchars=vert:\ ,eob:\ ,stlnc:  statusline=\  colorcolumn=0
        \ nofoldenable winhighlight=StatusLine:StatusLineNC
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

command! FocusWriting call s:focuswriting()

" }}}
" General: clean unicode {{{

" Replace unicode symbols with cleaned, ascii versions
function! s:clean_unicode()
  silent! execute '%s/”/"/g'
  silent! execute '%s/“/"/g'
  silent! execute "%s/’/'/g"
  silent! execute "%s/‘/'/g"
  silent! execute '%s/—/-/g'
  silent! execute '%s/…/.../g'
  silent! execute '%s/​//g'
endfunction

command! CleanUnicode call s:clean_unicode()

" }}}
" General: macro repeater {{{

" Allow '.' to repeat macros. Finally!
" Taken from here:
" https://vi.stackexchange.com/questions/11210/can-i-repeat-a-macro-with-the-dot-operator
" SR took it from GitHub: ckarnell/Antonys-macro-repeater
"
" When . repeats g@, repeat the last macro.
function! AtRepeat(_)
  " If no count is supplied use the one saved in s:atcount.
  " Otherwise save the new count in s:atcount, so it will be
  " applied to repeats.
  let s:atcount = v:count ? v:count : s:atcount
  " feedkeys() rather than :normal allows finishing in Insert
  " mode, should the macro do that. @@ is remapped, so 'opfunc'
  " will be correct, even if the macro changes it.
  call feedkeys(s:atcount.'@@')
endfunction

function! AtSetRepeat(_)
  set operatorfunc=AtRepeat
endfunction

" Called by g@ being invoked directly for the first time. Sets
" 'opfunc' ready for repeats with . by calling AtSetRepeat().
function! AtInit()
  " Make sure setting 'opfunc' happens here, after initial playback
  " of the macro recording, in case 'opfunc' is set there.
  set operatorfunc=AtSetRepeat
  return 'g@l'
endfunction

function! AtReg()
  let s:atcount = v:count1
  let l:c = nr2char(getchar())
  return '@'.l:c."\<plug>@init"
endfunction

function! QRepeat(_)
  call feedkeys('@'.s:qreg)
endfunction

function! QSetRepeat(_)
  set operatorfunc=QRepeat
endfunction

function! QStop()
  set operatorfunc=QSetRepeat
  return 'g@l'
endfunction

let s:qrec = 0
function! QStart()
  if s:qrec == 1
    let s:qrec = 0
    return "q\<plug>qstop"
  endif
  let s:qreg = nr2char(getchar())
  if s:qreg =~# '[0-9a-zA-Z"]'
    let s:qrec = 1
  endif
  return 'q'.s:qreg
endfunction

" }}}
" General: toggle numbers {{{

function! s:toggle_number()
  if &number == 0
    set number
  else
    set nonumber
  endif
endfunction

function! s:toggle_relative_number()
  if &relativenumber == 0
    set relativenumber
  else
    set norelativenumber
  endif
endfunction

command! ToggleNumber call s:toggle_number()
command! ToggleRelativeNumber call s:toggle_relative_number()

" }}}
" Package: markdown-preview.vim {{{

let g:mkdp_auto_start = v:false
let g:mkdp_auto_close = v:false

" set to 1, the vim will just refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = v:false

" set to 1, the MarkdownPreview command can be use for all files,
" by default it just can be use in markdown file
" default: 0
let g:mkdp_command_for_global = v:false

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle'
      \ }

" }}}
" Package: preview compiled stuff in viewer {{{

function! s:preview()
  if &filetype ==? 'rst'
    silent! execute 'terminal restview %'
    silent! execute "normal \<C-O>"
  elseif &filetype ==? 'markdown'
    " from markdown-preview.vim
    silent! execute 'MarkdownPreview'
  else
    silent! execute "!gio open '%:p'"
  endif
endfunction

command! Preview call s:preview()

" }}}
" Package: misc global var config {{{

" Languages: configure location of host
let g:python3_host_prog = "$HOME/.asdf/shims/python"

" Configure clipboard explicitly. Speeds up startup
let g:clipboard = {
      \ 'name': 'xsel',
      \ 'copy': {
      \    '+': 'xsel --clipboard --input',
      \    '*': 'xsel --clipboard --input',
      \  },
      \ 'paste': {
      \    '+': 'xsel --clipboard --output',
      \    '*': 'xsel --clipboard --output',
      \ },
      \ 'cache_enabled': 0,
      \ }

" Netrw: disable completely
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:netrw_nogx = 1

" WinResize:
let g:winresizer_start_key = '<C-\>'
let g:winresizer_vert_resize = 1
let g:winresizer_horiz_resize = 1

" Haskell: 'neovimhaskell/haskell-vim'
let g:haskell_enable_quantification = v:true   " to highlight `forall`
let g:haskell_enable_recursivedo = v:true      " to highlight `mdo` and `rec`
let g:haskell_enable_arrowsyntax = v:true      " to highlight `proc`
let g:haskell_enable_pattern_synonyms = v:true " to highlight `pattern`
let g:haskell_enable_typeroles = v:true        " to highlight type roles
let g:haskell_enable_static_pointers = v:true  " to highlight `static`

" Restructured Text
let g:no_rst_sections_maps = 0

" IndentLines:
let g:indentLine_enabled = v:false  " indentlines disabled by default

" HexMode: configure hex editing
" relevant command: Hexmode
let g:hexmode_patterns = '*.bin,*.exe,*.dat,*.o'
let g:hexmode_xxd_options = '-g 2'

" Makefile: global variable to prevent syntax highlighting of commands
let g:make_no_commands = 1

" vim-filetype-formatter:
let g:vim_filetype_formatter_verbose = v:false
let g:vim_filetype_formatter_ft_no_defaults = []
function! s:_ft_formatter_python()
  let filename = expand('%:p')
  return printf(
        \ 'ruff check -q --fix-only --stdin-filename="%s" - ' .
        \ '| black -q --stdin-filename="%s" - ' .
        \ '| isort -q --filename="%s" - ' .
        \ '| docformatter -',
        \ filename, filename, filename
        \ )
endfunction
let s:ft_formatter_python = funcref('s:_ft_formatter_python')
let g:vim_filetype_formatter_commands = {
      \ 'python': s:ft_formatter_python,
      \ }

" nvim-repl:
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

" }}}
