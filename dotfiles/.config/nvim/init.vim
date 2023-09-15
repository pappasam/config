" Packages {{{

function! s:packager_init(packager) abort
  call a:packager.add('https://github.com/kristijanhusak/vim-packager', {'type': 'opt'})
  " Autocompletion And IDE Features
  call a:packager.add('https://github.com/neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'})
  call a:packager.add('https://github.com/pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' })
  " TreeSitter
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter')
  call a:packager.add('https://github.com/nvim-treesitter/playground')
  call a:packager.add('https://github.com/windwp/nvim-ts-autotag')
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter-context')
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
  " Repl
  call a:packager.add('https://github.com/pappasam/nvim-repl')
  call a:packager.add('https://github.com/tpope/vim-repeat')
  " Syntax
  call a:packager.add('https://github.com/pappasam/papercolor-theme-slim')
  call a:packager.add('https://github.com/delphinus/vim-firestore')
  " Text Objects
  call a:packager.add('https://github.com/machakann/vim-sandwich')
  call a:packager.add('https://github.com/kana/vim-textobj-user')
  " Miscellaneous
  call a:packager.add('https://github.com/fidian/hexmode')
  call a:packager.add('https://github.com/sjl/strftimedammit.vim')
  call a:packager.add('https://github.com/windwp/nvim-autopairs')
  call a:packager.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:packager.add('https://github.com/pappasam/vim-keywordprg-commands')
  call a:packager.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})
  call a:packager.add('https://github.com/pappasam/vim-filetype-formatter')
endfunction

lua require('config/colorizer')
lua require('config/gitsigns')
lua require('config/nvim-autopairs')
lua require('config/nvim-tree')
lua require('config/nvim-treesitter')
lua require('config/nvim-ts-context-commentstring')
lua require('config/nvim-web-devicons')
lua require('config/telescope')
lua require('config/treesitter-context')

" }}}
" Settings {{{

filetype plugin indent on
set completeopt=menuone,longest wildmode=longest:full wildmenu
set shortmess+=c shortmess+=I
set hidden
set signcolumn=number
set cursorline
set mouse=a
set noswapfile
set cmdheight=2
set nowrap linebreak
set expandtab autoindent smartindent shiftwidth=2 softtabstop=2 tabstop=8
set isfname+=@-@ isfname+=:
set incsearch inccommand=nosplit
set dictionary=$HOME/config/docs/dict/american-english-with-propcase.txt
set spelllang=en_us
set nojoinspaces
set showtabline=2
set autoread
set grepprg=rg\ --vimgrep
set notimeout
set number
set splitright
set termguicolors
set background=dark
set colorcolumn=
set laststatus=2 ttimeoutlen=50 noshowmode
set noshowcmd
set updatetime=300
set path+=/usr/include/x86_64-linux-gnu/
set history=10
set diffopt+=internal,algorithm:patience
set list
set listchars=tab:>\ ,nbsp:+,leadmultispace:\ ,multispace:-
set foldenable foldmethod=marker foldnestmax=1
set tabline=%!CustomTabLine()
set laststatus=2
set statusline=%#CursorLine#\ %{mode()}\ %*\ %{&paste?'[P]':''}%{&spell?'[S]':''}%r%t%m%=\ %v:%l/%L\ %y\ %#CursorLine#\ %{&ff}\ %*\ %{strlen(&fenc)?&fenc:'none'}\  " Trailing space
colorscheme PaperColorSlim
digraph '' 699  " Hawaiian character ʻ
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-
let $PATH = $PWD . '/node_modules/.bin:' . $PATH
let g:mapleader = ','
let g:python3_host_prog = "$HOME/.asdf/shims/python"
let g:clipboard = {
      \ 'name': 'xsel',
      \ 'cache_enabled': 0,
      \ 'copy' : {'+': 'xsel --clipboard --input' , '*': 'xsel --clipboard --input' },
      \ 'paste': {'+': 'xsel --clipboard --output', '*': 'xsel --clipboard --output'},
      \ }
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
let g:mkdp_preview_options = {
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle',
      \ }
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

augroup init_vim_setup
  autocmd!
  autocmd Filetype vim call system(['git', 'clone', 'https://github.com/kristijanhusak/vim-packager', $HOME . '/.config/nvim/pack/packager/opt/vim-packager'])
        \ | packadd vim-packager
        \ | call packager#setup(function('s:packager_init'), {'window_cmd': 'edit'})
        \ | let &l:path .= ','.stdpath('config').'/lua'
        \ | setlocal suffixesadd^=.lua
augroup end

augroup nvim_tree_open_directory_on_vimenter
  autocmd!
  autocmd VimEnter * if exists(':NvimTreeOpen') && len(argv()) == 1 && isdirectory(argv(0))
        \ | execute 'NvimTreeOpen ' . argv(0)
        \ | endif
augroup end

augroup statusline_overrides
  autocmd!
  autocmd BufEnter NvimTree* setlocal statusline=\ NvimTree\ %#CursorLine#
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
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf,config,credentials,.editorconfig set filetype=dosini
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
  " Overrides to ensure correct default indentation
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  " 4 spaces per tab, not 2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  " Use hard tabs, not spaces
  autocmd Filetype make,tsv,votl,go,gomod setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " Fix weird stuff with snippet indentation
  autocmd Filetype snippets setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab noautoindent nosmartindent
augroup end

augroup comment_config
  " commentstring: read by vim-commentary; must be one template
  " comments: csv of comments.
  " formatoptions: influences how Vim formats text
  " ':help fo-table' will get the desired result
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
  autocmd FileType gitcommit setlocal nofoldenable
augroup end

augroup commit_newtab
  autocmd!
  autocmd FileType gitcommit if winnr("$") > 1 | wincmd T | endif
augroup end

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
augroup end

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

augroup fix_whitespace_on_save
  autocmd!
  autocmd BufWritePre * TrimWhitespace
augroup end

augroup coc_custom
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_coc()
augroup end

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

" }}}
" Mappings {{{

function! s:default_key_mappings()
  nnoremap <silent> zS <cmd>call <SID>syntax_group()<CR>
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'
  nnoremap ' ,
  inoremap <silent> <C-c> <Esc>:pclose <BAR> cclose <BAR> lclose <CR>a
  nnoremap <silent> <C-c> :pclose <BAR> cclose <BAR> lclose <CR>
  nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j v:count == 0 ? 'gj' : 'j'
  nnoremap <expr> <plug>@init AtInit()
  inoremap <expr> <plug>@init "\<c-o>".AtInit()
  nnoremap <expr> <plug>qstop QStop()
  inoremap <expr> <plug>qstop "\<c-o>".QStop()
  nmap <expr> @ AtReg()
  nmap <expr> q QStart()
  nnoremap <silent> <A-1> <Cmd>silent! 1tabnext<CR>
  nnoremap <silent> <A-2> <Cmd>silent! 2tabnext<CR>
  nnoremap <silent> <A-3> <Cmd>silent! 3tabnext<CR>
  nnoremap <silent> <A-4> <Cmd>silent! 4tabnext<CR>
  nnoremap <silent> <A-5> <Cmd>silent! 5tabnext<CR>
  nnoremap <silent> <A-6> <Cmd>silent! 6tabnext<CR>
  nnoremap <silent> <A-7> <Cmd>silent! 7tabnext<CR>
  nnoremap <silent> <A-8> <Cmd>silent! 8tabnext<CR>
  nnoremap <silent> <A-9> <Cmd>silent! $tabnext<CR>
  nnoremap gx <Cmd>call jobstart(['firefox', expand('<cfile>')])<CR>
  xnoremap gx :<C-u> call jobstart(['firefox', <SID>get_visual_selection(visualmode())])<CR><Esc>`<
  nnoremap <leader><leader>g <Cmd>FocusWriting<CR>
  nnoremap <silent> <leader><leader>h <Cmd>ResizeWindowHeight<CR>
  nnoremap <silent> <leader><leader>w <Cmd>ResizeWindowWidth<CR>
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y
  noremap <silent> <MiddleMouse> <LeftMouse>za
  noremap <silent> <2-MiddleMouse> <LeftMouse>za
  noremap <silent> <3-MiddleMouse> <LeftMouse>za
  noremap <silent> <4-MiddleMouse> <LeftMouse>za
  cnoreabbrev <expr> v <SID>abbr_only_beginning('v', 'edit ~/.config/nvim/init.vim')
  cnoreabbrev <expr> z <SID>abbr_only_beginning('z', 'edit ~/.zshrc')
  cnoreabbrev <expr> b <SID>abbr_only_beginning('b', 'edit ~/.bashrc')
  " https://github.com/neoclide/coc.nvim
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
  nnoremap <silent>        <space>l <Cmd>call <SID>coc_toggle_outline()<CR>
  " https://github.com/lewis6991/gitsigns.nvim
  nnoremap <silent> <leader>g <Cmd>Gitsigns toggle_signs<CR>
  " https://github.com/pappasam/nvim-repl
  nnoremap <leader><leader>e <Cmd>ReplToggle<CR>
  nmap     <leader>e         <Plug>ReplSendLine
  vmap     <leader>e         <Plug>ReplSendVisual
  " https://github.com/machakann/vim-sandwich
  nmap s <Nop>
  xmap s <Nop>
  " https://github.com/nvim-telescope/telescope.nvim
  nnoremap <silent> <C-p><C-p> <Cmd>Telescope find_files hidden=true<CR>
  nnoremap <silent> <C-p><C-b> <Cmd>Telescope buffers<CR>
  nnoremap <silent> <C-p><C-g> <Cmd>Telescope git_status<CR>
  nnoremap <silent> <C-n><C-n> <Cmd>Telescope live_grep<CR>
  nnoremap <silent> <C-n><C-w> <Cmd>Telescope grep_string<CR>
  nnoremap <silent> <C-n><C-h> <Cmd>Telescope help_tags<CR>
  " https://github.com/pappasam/vim-filetype-formatter
  nnoremap <silent> <leader>f <Cmd>silent! CocDisable<cr><Cmd>FiletypeFormat<cr><Cmd>silent! CocEnable<cr>
  vnoremap <silent> <leader>f <Cmd>silent! CocDisable<cr>:FiletypeFormat<cr><Cmd>silent! CocEnable<cr>
  " https://github.com/kyazdani42/nvim-tree.lua
  nnoremap <silent> <space>j <Cmd>NvimTreeFindFileToggle<CR>

  augroup map_filetype_overrides
    autocmd!
    autocmd FileType man,help
          \ nnoremap <buffer> d <C-d> |
          \ nnoremap <buffer> D <C-d> |
          \ nnoremap <buffer> u <C-u> |
          \ nnoremap <buffer> U <C-u> |
          \ nnoremap <buffer> <C-]> <C-]>
    autocmd FileType help nnoremap <buffer><silent> q <Cmd>close<CR>
  augroup end

  let &filetype=&filetype
endfunction

call s:default_key_mappings()

" https://stackoverflow.com/a/61486601
function! s:get_visual_selection(mode)
  " call with visualmode() as the argument
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end]     = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if a:mode ==# 'v'
    " Must trim the end before the start, the beginning will shift left.
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
  elseif a:mode ==# 'V'
    " Line mode no need to trim start or end
  elseif a:mode == "\<c-v>"
    " Block mode, trim every line
    let new_lines = []
    let i = 0
    for line in lines
      let lines[i] = line[column_start - 1: column_end - (&selection == 'inclusive' ? 1 : 2)]
      let i = i + 1
    endfor
  else
    return ''
  endif
  for line in lines
    echom line
  endfor
  return join(lines, "\n")
endfunction

function! s:abbr_only_beginning(in_command, out_command)
  if (getcmdtype() == ':' && getcmdline() =~ '^' . a:in_command . '$')
    return a:out_command
  else
    return a:in_command
  endif
endfunction

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

function! s:coc_toggle_outline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

" }}}
" Commands {{{

command! TrimWhitespace call s:trim_whitespace()
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

command! ResizeWindowWidth call s:resize_window_width()
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

command! ResizeWindowHeight call s:resize_window_height()
function! s:resize_window_height()
  normal! m`
  let initial = winnr()
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

command! FocusWriting call s:focuswriting()
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

command! CleanUnicode call s:clean_unicode()
function! s:clean_unicode()
  silent! execute '%s/”/"/g'
  silent! execute '%s/“/"/g'
  silent! execute "%s/’/'/g"
  silent! execute "%s/‘/'/g"
  silent! execute '%s/—/-/g'
  silent! execute '%s/…/.../g'
  silent! execute '%s/​//g'
endfunction

command! Preview call s:preview()
function! s:preview()
  if &filetype ==? 'markdown'
    " from markdown-preview.vim
    silent! execute 'MarkdownPreview'
  else
    silent! execute "!gio open '%:p'"
  endif
endfunction

" }}}
" Functions {{{

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

" Allow '.' to repeat macros. Finally!
" Taken from here:
" https://vi.stackexchange.com/questions/11210/can-i-repeat-a-macro-with-the-dot-operator
" SR took it from GitHub: ckarnell/Antonys-macro-repeater
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
