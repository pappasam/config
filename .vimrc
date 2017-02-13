" Notes --------- {{{

" -----------------------------------------------------------
" Text object selection
" object-select OR text-objects
" delete the inner (...) block where the cursor is.
" dib ( or 'di(' )
" -----------------------------------------------------------
"
" -----------------------------------------------------------
" The default mapping is cp, and can be followed by any motion or text object. For instance:

" cpiw => copy word into system clipboard
" cpi' => copy inside single quotes to system clipboard
" In addition, cP is mapped to copy the current line directly.

" The sequence cv is mapped to paste the content of system clipboard to the next line.
" -----------------------------------------------------------
"
" -----------------------------------------------------------
"  Enable and disable folding
"  zi
" -----------------------------------------------------------
"
" How to insert parens purely
" There are 3 ways
" 1. use Ctrl-V ) to insert paren without trigger the plugin.
" 2. use Alt-P to turn off the plugin.
" 3. use DEL or <C-O>x to delete the character insert by plugin.
"
" }}}
" Leader mappings -------------------- {{{
let mapleader = ","
let maplocalleader = "\\"
" }}}
" Display settings / general config ------------ {{{

" Enable buffer deletion instead of having to write each buffer
set hidden

" Remove GUI mouse support
" This support is actually annoying, because I may occasionally
" use the mouse to select text or something, and don't actually
" want the cursor to move
set mouse=""

" Automatically change directory to current file
" set autochdir

" Prevent creation of swap files
set nobackup
set noswapfile

set wrap

" Set column to light grey at 80 characters
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
endif

" Don't highlight all search results
set nohlsearch

" Remove query for terminal version
" This prevents un-editable garbage characters from being printed
" after the 80 character highlight line
set t_RV=

filetype plugin indent on

augroup cursorline_setting
  autocmd!
  autocmd WinEnter,BufEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

set spelllang=en_us

set showtabline=2

set autoread

" }}}
" Plugins --------------------- {{{
call plug#begin('~/.vim/plugged')

" Basics
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-rooter'
Plug 'qpkorr/vim-bufkill'
Plug 'christoomey/vim-system-copy'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'troydm/zoomwintab.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dkprice/vim-easygrep'
Plug 't9md/vim-choosewin'
Plug 'mhinz/vim-startify'
Plug 'gcmt/taboo.vim'
Plug 'yssl/QFEnter'
Plug 'djoshea/vim-autoread'
Plug 'justinmk/vim-sneak'

" Tagbar
Plug 'marijnh/tern_for_vim', { 'do': 'npm install'  }  " for javascript
Plug 'majutsushi/tagbar'
" Additional requirement - sudo npm install -g jsctags

" Basic coloring
Plug 'bronson/vim-trailing-whitespace'
Plug 'NLKNguyen/papercolor-theme'

" Utils
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'jiangmiao/auto-pairs'

" Language-specific syntax
Plug 'derekwyatt/vim-scala',
Plug 'wting/rust.vim'
Plug 'hdima/python-syntax',
Plug 'autowitch/hive.vim'
Plug 'elzr/vim-json',
Plug 'vimoutliner/vimoutliner'
Plug 'cespare/vim-toml'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'plasticboy/vim-markdown'
Plug 'ElmCast/elm-vim'
Plug 'mopp/rik_octave.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'StanAngeloff/php.vim'
Plug 'vim-scripts/SAS-Syntax'
Plug 'neovimhaskell/haskell-vim'
Plug 'aklt/plantuml-syntax'
Plug 'NLKNguyen/c-syntax.vim'
Plug 'octol/vim-cpp-enhanced-highlight'

" Indentation
Plug 'hynek/vim-python-pep8-indent'
Plug 'Yggdroot/indentLine'

" Web Development - Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'groenewege/vim-less'
Plug 'heavenshell/vim-jsdoc'

" Web Development - General
Plug 'mattn/emmet-vim'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'

" C and C++
Plug 'derekwyatt/vim-fswitch'

" Rainbow
Plug 'junegunn/rainbow_parentheses.vim'

call plug#end()
" }}}
" Plugin configuration ------------ {{{

" Papercolor
let g:PaperColor_Python_Highlight_Builtins = 1

" fswitch - change from .c/.cpp to .h
nnoremap <silent> <leader>h :FSHere<cr>

" C++
let g:cpp_experimental_simple_template_highlight = 1

" QFEnter config
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_topen_map = ['<C-t>']

" Taboo
" Tab format hardcoded to main for now since I often do this anyway
let g:taboo_tab_format = ' [main %N]%m '
let g:taboo_renamed_tab_format = ' [%l]%m '

" startify
let g:startify_list_order = ['dir', 'files', 'bookmarks', 'sessions',
        \ 'commands']

" choosewin
nnoremap <leader>w :ChooseWin<CR>

" Haskell 'neovimhaskell/haskell-vim'
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`

" Python highlighting
let python_highlight_all = 1

" Ragtag on every filetype
let g:ragtag_global_maps = 1

" Vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" JSX for .js files in addition to .jsx
let g:jsx_ext_required = 0

" js-doc
let g:jsdoc_enable_es6 = 1

" NERDTree
let NERDTreeShowLineNumbers = 1
let NERDTreeCaseSensitiveSort = 0
let NERDTreeWinPos = 'left'
let NERDTreeWinSize = 31
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore=['venv$[[dir]]', '__pycache__$[[dir]]', 'node_modules$[[dir]]']

" Toggle NERDTree with current buffer dir, keeping cursor in original window
" nnoremap <silent> <space>j :NERDTreeToggle %<CR>
nnoremap <silent> <space>j :NERDTreeTabsToggle<CR>

" EasyGrep - use git grep
set grepprg=git\ grep\ -n\ $*
let g:EasyGrepCommand = 1 " use grep, NOT vimgrep
let g:EasyGrepJumpToMatch = 0 " Do not jump to the first match

" Ctrl p
let g:ctrlp_working_path_mode = 'rw' " start from cwd
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" open first in current window and others as hidden
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_use_caching = 0


" Rainbow
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']']]
augroup rainbow_settings
  " Section to turn on rainbow parentheses
  autocmd!
  autocmd BufEnter,BufRead * :RainbowParentheses
  autocmd BufEnter,BufRead *.html,*.css,*.jxs,*.js :RainbowParentheses!
augroup END

" vim-fugitive
" DO NOT USE THESE MAPPINGS BELOW Vim version 8
" version 8 solves some async issues
" https://github.com/tpope/vim-fugitive/issues/648
" fugitive and vim-airline overlap; TPope needs to fix some bugs
" date of note: 2017-01-13
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>g. :Git add .<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>

" indentlines
let g:indentLine_enabled = 0  " indentlines disabled by default
nnoremap <silent> <leader>i :IndentLinesToggle<CR>

"  }}}
" Airline Configuration ---------------- {{{
set laststatus=2
set ttimeoutlen=50
set noshowmode
let g:airline_theme='powerlineish'
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#virtualenv#enabled = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.spell = 'Ꞩ'
function! GetSmallPath()
  " For /a/b/c/hello, return c/hello
  return expand('%:p:h:t') . '/' . expand('%:t')
endfunction
let g:airline_section_c = airline#section#create(['%{GetSmallPath()}'])
let g:airline_section_x = airline#section#create(['col %c'])
let g:airline_section_y = airline#section#create(['ffenc'])
let g:airline_section_z = airline#section#create(['filetype'])
let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse=0
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'ℕ',
    \ 'i'  : 'ⅈ',
    \ 'R'  : 'ℛ',
    \ 'c'  : 'ℂ',
    \ 'v'  : '℣',
    \ 'V'  : '℣',
    \ '' : '℣',
    \ 's'  : '₷',
    \ 'S'  : '₷',
    \ '' : '₷',
    \ }
" }}}
"  Tagbar Configuration ------ {{{
let g:tagbar_show_linenumbers = -1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1
let g:tagbar_sort = 0  " order by order in sort file
let g:tagbar_case_insensitive = 1
let g:tagbar_width = 37
let g:tagbar_silent = 1
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

" Toggle TagBar, keeping cursor in original window
nnoremap <silent> <space>l :TagbarToggle <CR>
"  }}}
" Set number display ------------- {{{

function! ToggleRelativeNumber()
  if &rnu
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

function! RNUInsertEnter()
  if &rnu
    let w:line_number_state = 'rnu'
    set norelativenumber
  else
    let w:line_number_state = 'nornu'
  endif
endfunction

function! RNUInsertLeave()
  if w:line_number_state == 'rnu'
    set relativenumber
  else
    set norelativenumber
    let w:line_number_state = 'nornu'
  endif
endfunction

function! RNUWinEnter()
  if exists('w:line_number_state')
    if w:line_number_state == 'rnu'
      set relativenumber
    else
      set norelativenumber
    endif
  else
    set relativenumber
    let w:line_number_state = 'rnu'
  endif
endfunction

function! RNUWinLeave()
  if &rnu
    let w:line_number_state = 'rnu'
  else
    let w:line_number_state = 'nornu'
  endif
  set norelativenumber
endfunction

" Set mappings for relative numbers

" Toggle relative number status
nnoremap <silent><leader>r :call ToggleRelativeNumber()<CR>

" autocmd that will set up the w:created variable
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1
set number relativenumber
augroup rnu_nu
  autocmd!
  "Initial window settings
  autocmd WinEnter * if !exists('w:created') | setlocal number relativenumber | endif
  " Don't have relative numbers during insert mode
  autocmd InsertEnter * :call RNUInsertEnter()
  autocmd InsertLeave * :call RNUInsertLeave()
  " Set and unset relative numbers when buffer is active
  autocmd WinEnter * :call RNUWinEnter()
  autocmd WinLeave * :call RNUWinLeave()
augroup end


" }}}
"  Zeal --------- {{{

" Zeal documentation functions to search zeal from both normal mode
" and visual mode
" Clean up these functions tomorrow to deal with more general cases
" of zeal documentation

function! s:get_visual_selection()
  " Helper function to get visual selection into a variable
  " Why is this not a built-in Vim script function?!
  " Taken from xolox on stackoverflow
  " http://stackoverflow.com/questions/1533565/
  " how-to-get-visually-selected-text-in-vimscript
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! s:ZealString(docset, query)
  let cmd_begin = '!(pkill zeal || true) && (zeal --query '
  let doc_escape = shellescape(a:docset)
  let query_escape = shellescape(a:query)
  let cmd_end = ' &) > /dev/null'
  return cmd_begin . doc_escape . ':' . query_escape . cmd_end
endfunction

function! ZealNormal(docset)
  call inputsave()
  let docset = input("Zeal Docset: ", a:docset)
  let query = input("Zeal Query: ", expand('<cword>'))
  call inputrestore()
  let cmd = s:ZealString(docset, query)
  silent execute cmd
endfunction

function! ZealVisual(docset)
  call inputsave()
  let docset = input("Zeal Docset: ", a:docset)
  let query = input("Zeal Query: ", s:get_visual_selection())
  call inputrestore()
  let cmd = s:ZealString(docset, query)
  silent execute cmd
endfunction

" Key bindings for zeal functions
nnoremap <leader>z :call ZealNormal(&filetype)<CR><CR><c-l><CR>
vnoremap <leader>z :call ZealVisual(&filetype)<CR><CR><c-l><CR>

"  }}}
" Filetypes ------------ {{{
augroup filetype_recognition
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.md,*.markdown set filetype=markdown
  autocmd BufNewFile,BufRead,BufEnter *.hql,*.q set filetype=hive
  autocmd BufNewFile,BufRead,BufEnter *.config set filetype=yaml
  autocmd BufNewFile,BufRead,BufEnter *.bowerrc,*.babelrc,*.eslintrc set filetype=json
  autocmd BufNewFile,BufRead,BufEnter *.handlebars set filetype=html
  autocmd BufNewFile,BufRead,BufEnter *.m,*.oct set filetype=octave
  autocmd BufNewFile,BufRead,BufEnter *.jsx set filetype=javascript.jsx
  autocmd BufNewFile,BufRead,BufEnter *.cfg,*.ini,.coveragerc,.pylintrc set filetype=dosini
augroup END
nnoremap <leader>jx :set filetype=javascript.jsx<CR>
nnoremap <leader>jj :set filetype=javascript<CR>

augroup filetype_vim
  autocmd!
  autocmd BufWritePost *vimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

augroup quick_fix_move_bottom
  autocmd!
  autocmd FileType qf wincmd J
augroup END
" }}}
" General Key remappings ----------------------- {{{

" Move up and down visually only if count is specified before
" Otherwise, you want to move up lines numerically
" e.g. ignoring wrapped lines
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" Move to beginning and end of visual line
nnoremap 0 g0
nnoremap $ g$

" Enable pasting without having to do 'set paste'
set pastetoggle=fj

" Quickfix window automatically close after selecting file
augroup quickfix_sr
  autocmd!
  " did away with this option for now, typing cclose is easy
  " autocmd FileType qf silent! nnoremap <buffer> <CR> <CR>:cclose<CR>
augroup END

" moving forward and backward with vim tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" placing commas one line down
" usable with repeat operator '.'
nnoremap <silent> <Plug>NewLineComma f,wi<CR><Esc>
      \:call repeat#set("\<Plug>NewLineComma")<CR>
nmap <leader><CR> <Plug>NewLineComma

" }}}
" Command abbreviations ------------------------ {{{

" abbreviate creating tab, vertical, and horizontal buffer splits
cabbrev bt tab sb
cabbrev bv vert sb
cabbrev bs sbuffer

" make it easier to type TabooRename
cabbrev : TabooRename

" fix misspelling of ls
cabbrev LS ls
cabbrev lS ls
cabbrev Ls ls

" fix misspelling of vs and sp
cabbrev SP sp
cabbrev sP sp
cabbrev Sp sp
cabbrev VS vs
cabbrev vS vs
cabbrev Vs vs

" echo current file path
cabbrev fp echo expand('%:p')

" Plug update and upgrade
cabbrev pu PlugUpdate <BAR> PlugUpgrade

" }}}
" Folding Settings --------------- {{{
augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType * setlocal foldnestmax=1
augroup END
nnoremap z<space> zA

" }}}
" Buffers and Windows ----------------- {{{
" Change change window thorough Control + directional movement
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> <C-h> :wincmd h<CR>

" Change change window width and height with capital movement letters
nnoremap <silent> K <c-w>+
nnoremap <silent> J <c-w>-
nnoremap <silent> H <c-w><
nnoremap <silent> L <c-w>>

" Switch buffers
nnoremap gn :bn<CR>
nnoremap gd :BD<CR>
nnoremap gp :bp<CR>

" Navigate within one window
nnoremap gt H
nnoremap gb L
nnoremap g. M

" }}}
" Syntax coloring ---------------- {{{
try
  set t_Co=256 " says terminal has 256 colors
  set background=dark
  colorscheme PaperColor
catch
endtry

" Highlight self and cls keyword in class definitions
augroup python
  autocmd!
  autocmd FileType python syn keyword pythonBuiltinObj self
  autocmd FileType python syn keyword pythonBuiltinObj cls
augroup end
" }}}
" Trailing whitespace ------------- {{{
augroup fix_whitespace_save
  autocmd!
  let blacklist = ['markdown']
  autocmd BufWritePre * if index(blacklist, &ft) < 0 | execute ':FixWhitespace'
augroup END
" }}}
" Tabs versus Spaces ( Indentation )------------- {{{

" Note -> apparently BufRead, BufNewFile trumps Filetype
" Eg, if BufRead,BufNewFile * ignores any Filetype overwrites
" This is why default settings are chosed with Filetype *
augroup indentation_sr
  autocmd!
  autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype python,c,elm,haskell setlocal shiftwidth=4 softtabstop=4 tabstop=8
  autocmd Filetype dot setlocal autoindent cindent
  autocmd BufRead,BufNewFile *.otl,*GNUmakefile,*makefile,*Makefile,*.tsv
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
augroup END
" }}}
" Writing ------------------ {{{
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_no_default_key_mappings=1
augroup writing
  autocmd!
  autocmd FileType markdown :setlocal wrap linebreak nolist
  autocmd FileType markdown :setlocal colorcolumn=0
  autocmd BufNewFile,BufRead *.html,*.txt,*.tex :setlocal wrap linebreak nolist
  autocmd BufNewFile,BufRead *.html,*.txt,*.tex :setlocal colorcolumn=0
augroup END
" }}}
