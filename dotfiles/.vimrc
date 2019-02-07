" Author: Samuel Roeca <samuel.roeca@gmail.com>
"
" Notes:
"   * To toggle sections below, scroll over a folded section and type 'za'
"     when in Normal mode.
" Additional Notes --------- {{{
"
" This is my .vimrc. Hopefully you enjoy using it as much as me!
" I use the latest Linux Mint, but this will probably work with any Linux-based
" OS. My workflow is terminal-based and I now use Neovim
"
" PreRequisites:
"   To get the most out of this vimrc, please install the following
"   system dependencies. This may not be comprehensive, but represents
"   some basics I believe everyone should have that you might not have
"   by default on a modern Ubuntu-based OS:
"   * git && build-essential && curl
"   * nodejs && npm
"   * rust && cargo
"   * exuberant-ctags
"
" Installation:
"   1. Put file in correct place within filesystem
"     If using Vim, soft-link this file to ~/.vimrc
"     If using NeoVim, soft-link this file to ~/.config/nvim/init.vim
"   2. Install Vim-Plug (a great plugin manager)
"     As of August 20, 2017, you just need to run this command:
"     curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   3. Open vim (hint: type vim at command line and press enter :p)
"   4. :PlugInstall
"   5. :PlugUpdate
"   6. :PlugUpgrade

" TextObjectSelection:
" object-select OR text-objects
" delete the inner (...) block where the cursor is.
" dib ( or 'di(' )
" -----------------------------------------------------------
" SystemCopy:
" The default mapping is cp, and can be followed by any motion or text object.
" For instance:

" cpiw => copy word into system clipboard
" cpi' => copy inside single quotes to system clipboard
" In addition, cP is mapped to copy the current line directly.

" The sequence cv is mapped to paste the content of system clipboard
" to the next line.
" -----------------------------------------------------------
"  Folding:
"  zi: toggles everything
"  za: toggles the current section
" -----------------------------------------------------------
" ParenInsertion:
" There are 3 ways
" 1. use Ctrl-V ) to insert paren without trigger the plugin.
" 2. use Alt-P to turn off the plugin.
" 3. use DEL or <C-O>x to delete the character insert by plugin.
" 4. (more recently): type <C-l> in insert mode to delete right character
"
" QuickfixAndLocationList:
" ccl: close quickfix (my abbreviation: cc)
" cw: open quickfix if there is anything to open
" lcl: close location list (my abbreviation: lc)
" lw: open location list if there is anything to open
"
" InsertModeEditing:
" TLDR
"   :help insert-index
" CTRL-H   delete the character in front of the cursor
" CTRL-W   delete the word in front of the cursor
" CTRL-U   delete all characters in front of the cursor
" CTRL-L   delete character under cursor (I create this in general remappings)
"
" CommandMode:
" q: -> open the command editing window
"
" ExMode:
" Q -> opens ex mode
" To lean more about the ex editor, type 'man ex'

" }}}
" General: Terminal eumlator difference functions --- {{{

" s:is_console::
" Checks to see if Vim is running in console mode
function! IsConsole()
  return $TERM == 'linux'
endfunction

" s:if_console::
" The 88-bit ASCII/Not full unicode console is different than alacritty
" Return different value the console is true
function! IfConsole(lambda_true, lambda_false)
  return IsConsole() ? a:lambda_true() : a:lambda_false()
endfunction

" }}}
" General: Leader mappings -------------------- {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" General: global config ------------ {{{

"A comma separated list of options for Insert mode completion
"   menuone  Use the popup menu also when there is only one match.
"            Useful when there is additional information about the
"            match, e.g., what file it comes from.

"   longest  Only insert the longest common text of the matches.  If
"            the menu is displayed you can use CTRL-L to add more
"            characters.  Whether case is ignored depends on the kind
"            of completion.  For buffer text the 'ignorecase' option is
"            used.

"   preview  Show extra information about the currently selected
"            completion in the preview window.  Only works in
"            combination with 'menu' or 'menuone'.
set completeopt=menuone,longest,preview

" Enable buffer deletion instead of having to write each buffer
set hidden

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set nobackup
set noswapfile

" Do not wrap lines by default
set nowrap

" Search result highlighting
set incsearch
set inccommand=nosplit
augroup sroeca_incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Remove query for terminal version
" This prevents un-editable garbage characters from being printed
" after the 80 character highlight line
set t_RV=

filetype plugin indent on

set dictionary=$HOME/.american-english-with-propcase.txt

set spelllang=en_us

" Do not add two spaces after '.', '!', and '?'
" Useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

set autoread

" When you type the first tab hit will complete as much as possible,
" the second tab hit will provide a list, the third and subsequent tabs
" will cycle through completion options so you can complete the file
" without further keys
set wildmode=longest,list,full
set wildmenu

" Grep: program is 'git grep'
" set grepprg=git\ grep\ -n\ $*
set grepprg=rg\ --vimgrep

" Pasting: enable pasting without having to do 'set paste'
" NOTE: this is actually typed <C-/>, but vim thinks this is <C-_>
set pastetoggle=<C-_>

" Turn off complete vi compatibility
set nocompatible

" Enable using local vimrc
set exrc

" Make terminal zsh
set shell=/usr/bin/zsh

" Make sure numbering is set
set number

" Set split settings (options: splitright, splitbelow)
set splitright

" Redraw window whenever I've regained focus
augroup redraw_on_refocus
  au FocusGained * :redraw!
augroup END

" }}}
" General: Plugin Install --------------------- {{{

call plug#begin('~/.vim/plugged')

" Basics
Plug 'itchyny/lightline.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'christoomey/vim-system-copy'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 't9md/vim-choosewin'
Plug 'mhinz/vim-startify'
Plug 'yssl/QFEnter'
Plug 'djoshea/vim-autoread'
Plug 'simeji/winresizer'
Plug 'mbbill/undotree'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'henrik/vim-indexed-search'
Plug 'machakann/vim-sandwich'
" Plug 'unblevable/quick-scope'
Plug 'pappasam/quick-scope', { 'branch': 'FIX_CHANGING_CURSOR' }
Plug 'fcpg/vim-altscreen'
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'sjl/strftimedammit.vim'
Plug 'wincent/ferret'
Plug 'bronson/vim-visual-star-search'
Plug 'romainl/vim-devdocs'
Plug 'chrisbra/Colorizer'
Plug 'fidian/hexmode'
Plug 'wellle/targets.vim'

" Relative Numbering
Plug 'myusuf3/numbers.vim'

" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Git
Plug 'lambdalisue/gina.vim'
Plug 'junegunn/gv.vim'

" Basic coloring
Plug 'NLKNguyen/papercolor-theme'

" Utils
Plug 'tpope/vim-commentary'
" Convert to snakecase/camelcase/etc
Plug 'tpope/vim-abolish'
Plug 'jiangmiao/auto-pairs'

" Syntax highlighting
Plug 'derekwyatt/vim-scala'
Plug 'rust-lang/rust.vim'
Plug 'ron-rs/ron.vim'
Plug 'hdima/python-syntax'
Plug 'autowitch/hive.vim'
Plug 'elzr/vim-json'
Plug 'vimoutliner/vimoutliner'
Plug 'cespare/vim-toml'
Plug 'maralla/vim-toml-enhance'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'ElmCast/elm-vim'
Plug 'mopp/rik_octave.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'StanAngeloff/php.vim'
Plug 'vim-scripts/SAS-Syntax'
Plug 'neovimhaskell/haskell-vim'
Plug 'pappasam/plantuml-syntax'
Plug 'NLKNguyen/c-syntax.vim'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-vagrant'
Plug 'lervag/vimtex'
Plug 'tomlion/vim-solidity'
Plug 'jparise/vim-graphql'
Plug 'magicalbanana/sql-syntax-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'groenewege/vim-less'
Plug 'farfanoide/vim-kivy'
Plug 'raimon49/requirements.txt.vim'
Plug 'chr4/nginx.vim'
Plug 'othree/html5.vim'
Plug 'pearofducks/ansible-vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'mattn/vim-xxdcursor'

" Accounting
Plug 'ledger/vim-ledger'

" Autocompletion
Plug 'marijnh/tern_for_vim'
Plug 'davidhalter/jedi-vim'
" Additional requirements:
"   ln -s /home/sroeca/dotfiles/.tern-project /home/sroeca/.tern-project
Plug 'Rip-Rip/clang_complete'
" for C header filename completion:
Plug 'xaizek/vim-inccomplete'
Plug 'racer-rust/vim-racer'
" Addional requirements:
"   cargo install racer
"   rustup component add rust-src
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'fatih/vim-go'
Plug 'wannesm/wmgraphviz.vim'  " dotlanguage
" note: must run 'gem install neovim' to get this to work
" might require the neovim headers
Plug 'juliosueiras/vim-terraform-completion'
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" Tagbar
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'
" Additional requirements
"   npm install -g jsctags
"   sudo apt install -y php

" Indentation-only
Plug 'vim-scripts/groovyindent-unix'
Plug 'hynek/vim-python-pep8-indent'
Plug 'Yggdroot/indentLine'

" Web Development - General
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-ragtag'
Plug 'heavenshell/vim-jsdoc'

" Writing helpers
Plug 'dkarter/bullets.vim'
Plug 'gu-fan/riv.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-sentence'
Plug 'reedes/vim-wordy'
Plug 'reedes/vim-litecorrect'
Plug 'tommcdo/vim-exchange'

" Previewers
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'

" Code prettifiers
Plug 'pappasam/vim-filetype-formatter'

" C Programming
Plug 'ericcurtin/CurtineIncSw.vim'

call plug#end()

" }}}
" General: Filetype specification ------------ {{{

augroup filetype_recognition
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.hql,*.q set filetype=hive
  autocmd BufNewFile,BufRead,BufEnter *.config set filetype=yaml
  autocmd BufNewFile,BufRead,BufEnter *.bowerrc,*.babelrc,*.eslintrc,*.slack-term
        \ set filetype=json
  autocmd BufNewFile,BufRead,BufEnter *.asm set filetype=nasm
  autocmd BufNewFile,BufRead,BufEnter *.handlebars set filetype=html
  autocmd BufNewFile,BufRead,BufEnter *.m,*.oct set filetype=octave
  autocmd BufNewFile,BufRead,BufEnter *.jsx set filetype=javascript.jsx
  autocmd BufNewFile,BufRead,BufEnter *.gs set filetype=javascript
  autocmd BufNewFile,BufRead,BufEnter *.cfg,*.ini,.coveragerc,*pylintrc
        \ set filetype=dosini
  autocmd BufNewFile,BufRead,BufEnter *.tsv set filetype=tsv
  autocmd BufNewFile,BufRead,BufEnter Dockerfile.* set filetype=Dockerfile
  autocmd BufNewFile,BufRead,BufEnter Makefile.* set filetype=make
  autocmd BufNewFile,BufRead,BufEnter poetry.lock set filetype=toml
augroup END

augroup filetype_vim
  autocmd!
  autocmd BufWritePost *vimrc so $MYVIMRC |
        \if has('gui_running') |
        \so $MYGVIMRC |
        \endif
augroup END

" }}}
" General: Indentation (tabs, spaces, width, etc)------------- {{{

" Note -> apparently BufRead, BufNewFile trumps Filetype
" Eg, if BufRead,BufNewFile * ignores any Filetype overwrites
" This is why default settings are chosen with Filetype *
augroup indentation_sr
  autocmd!
  autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype python,c,elm,haskell,markdown,rust,rst,kv,nginx,asm,nasm
        \ setlocal shiftwidth=4 softtabstop=4 tabstop=8
  autocmd Filetype dot setlocal autoindent cindent
  autocmd Filetype make,tsv,votl,go
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>

  autocmd Filetype ron setlocal cindent
        \ cinkeys=0{,0},0(,0),0[,0],:,0#,!^F,o,O,e
        \ cinoptions+='(s,m2'
        \ cinoptions+='(s,U1'
        \ cinoptions+='j1'
        \ cinoptions+='J1'
augroup END

" }}}
" General: colorColumn different widths for different filetypes --- {{{

highlight ColorColumn ctermbg=9
set colorcolumn=80
augroup colorcolumn_configuration
  autocmd!
  autocmd FileType gitcommit setlocal colorcolumn=72 textwidth=72
  autocmd Filetype html,text,markdown set colorcolumn=0
augroup END

" }}}
" General: Writing (non-coding)------------------ {{{

" Notes:
"   indenting and de-indenting in insert mode are:
"     <C-t> and <C-d>
"   formatting hard line breaks
"     NORMAL
"       gqap => format current paragraph
"       gq => format selection
"     VISUAL
"       J => join all lines

" My custom litecorrect options
let g:litecorrect_custom_user_dict = {
      \ 'maybe': ['mabye'],
      \ 'medieval': ['medival', 'mediaeval', 'medevil'],
      \ 'then': ['hten'],
      \ }

augroup writing
  autocmd!
  autocmd FileType markdown,rst,gitcommit
        \ setlocal wrap linebreak nolist spell
        \ | call textobj#sentence#init()
        \ | call litecorrect#init(g:litecorrect_custom_user_dict)
  autocmd BufNewFile,BufRead *.html,*.txt,*.tex :setlocal wrap linebreak nolist
augroup END

" }}}
" General: Word definition and meaning lookup --- {{{

" Enable looking up values in either a dictionary or a thesaurus
" these are expected to be either:
"   Dict: dict-gcide
"   Thesaurus: dict-moby-thesaurus
function! ReadDictToPreview(word, dict) range
  let dst = tempname()
  execute "silent ! dict -d " . a:dict . " " . string(a:word) . " > " . dst
  pclose! |
        \ execute "silent! pedit! " . dst |
        \ wincmd P |
        \ set modifiable noreadonly |
        \ call append(0, 'This is a scratch buffer in a preview window') |
        \ set buftype=nofile nomodifiable noswapfile readonly nomodified |
        \ setlocal nobuflisted |
        \ execute "resize " . (line('$') + 1)
  execute ":redraw!"
endfunction

command! -nargs=1 Def call ReadDictToPreview(<q-args>, "gcide")
command! -nargs=1 Syn call ReadDictToPreview(<q-args>, "moby-thesaurus")

 " }}}
" General: Folding Settings --------------- {{{

augroup fold_settings
  autocmd!
  autocmd FileType vim,tmux setlocal foldmethod=marker
  autocmd FileType vim,tmux setlocal foldlevelstart=0
  autocmd FileType vim,tmux setlocal foldnestmax=1
  autocmd FileType ledger setlocal foldmethod=syntax
  autocmd BufNewFile,BufRead .zprofile,.profile,.bashrc,.zshrc setlocal foldmethod=marker
  autocmd BufNewFile,BufRead .zprofile,.profile,.bashrc,.zshrc setlocal foldlevelstart=0
augroup END

" }}}
" General: Trailing whitespace ------------- {{{

function! TrimWhitespace()
  let l:save = winsaveview()
  if &ft == 'markdown'
    " Replace lines with only trailing spaces
    %s/^\s\+$//e
    " Replace lines with exactly one trailing space with no trailing spaces
    %g/\S\s$/s/\s$//g
    " Replace lines with more than 2 trailing spaces with 2 trailing spaces
    %s/\s\s\s\+$/  /e
  else
    " Remove all trailing spaces
    %s/\s\+$//e
  endif
  call winrestview(l:save)
endfunction

augroup fix_whitespace_save
  autocmd!
  autocmd BufWritePre * call TrimWhitespace()
augroup END

" }}}
" General: Syntax highlighting ---------------- {{{

" Papercolor: options
let g:PaperColor_Theme_Options = {}
let g:PaperColor_Theme_Options.theme = {}

" Bold and italics are enabled by default
let g:PaperColor_Theme_Options.theme.default = {
      \ 'allow_bold': 1,
      \ 'allow_italic': 1
      \ }

" Terminal Changes:
" folds: grey + green
" visual: light blue background, black foreground
let g:PaperColor_Theme_Options.theme['default.dark'] = {}
let g:PaperColor_Theme_Options.theme['default.dark'].override = {
      \ 'folded_fg' : ['#d787ff', '10'],
      \ 'folded_bg' : ['#5f005f', '239'],
      \ 'visual_fg' : ['#000000', '0'],
      \ 'visual_bg' : ['#8787af', '6'],
      \ }

" Enable language-specific overrides
let g:PaperColor_Theme_Options.language = {
      \    'python': {
      \      'highlight_builtins' : 1
      \    },
      \    'cpp': {
      \      'highlight_standard_library': 1
      \    },
      \    'c': {
      \      'highlight_builtins' : 1
      \    }
      \ }

" Python: Highlight self and cls keyword in class definitions
augroup python_syntax
  autocmd!
  autocmd FileType python syn keyword pythonBuiltinObj self
  autocmd FileType python syn keyword pythonBuiltinObj cls
  autocmd FileType python syn keyword pythonBuiltinObj args
  autocmd FileType python syn keyword pythonBuiltinObj kwargs
augroup end

" Javascript: Highlight this keyword in object / function definitions
augroup javascript_syntax
  autocmd!
  autocmd FileType javascript syn keyword jsBooleanTrue this
  autocmd FileType javascript.jsx syn keyword jsBooleanTrue this
augroup end

" QuickScope: Primary green, secondary blue
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary ctermfg=10
  autocmd ColorScheme * highlight QuickScopeSecondary ctermfg=14
  if !IsConsole()
    autocmd ColorScheme * highlight QuickScopePrimary cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary cterm=underline
  endif
augroup END

augroup spelling_options
  autocmd!
  autocmd ColorScheme * highlight clear SpellBad
  autocmd ColorScheme * highlight clear SpellRare
  autocmd ColorScheme * highlight clear SpellCap
  autocmd ColorScheme * highlight clear SpellLocal
  autocmd ColorScheme * highlight SpellBad ctermfg=1    " Red
  autocmd ColorScheme * highlight SpellRare ctermfg=2   " Green
  autocmd ColorScheme * highlight SpellCap ctermfg=11    " Yellow
  autocmd ColorScheme * highlight SpellLocal ctermfg=5  " Purple
  if !IsConsole()
    autocmd ColorScheme * highlight SpellBad cterm=underline,italic
    autocmd ColorScheme * highlight SpellRare cterm=underline,italic
    autocmd ColorScheme * highlight SpellCap cterm=underline,italic
    autocmd ColorScheme * highlight SpellLocal cterm=underline,italic
  endif
augroup END

" 6 == relaxing blue
highlight EOLWS ctermbg=6 guibg=6
match EOLWS /\s\+$/
augroup whitespace_color
  autocmd!
  autocmd ColorScheme * highlight mkdLineBreak ctermbg=6
  autocmd ColorScheme * highlight EOLWS ctermbg=6

  autocmd InsertEnter * highlight EOLWS NONE
  autocmd InsertLeave * highlight EOLWS ctermbg=6

  autocmd InsertEnter * highlight mkdLineBreak NONE
  autocmd InsertLeave * highlight mkdLineBreak ctermbg=6
augroup END

" Syntax: select global syntax scheme
" Make sure this is at end of section
try
  call IfConsole(
        \ {-> execute('set t_Co=16')},
        \ {-> execute('set t_Co=256')}
        \ )
  set background=dark
  colorscheme PaperColor
catch
  echo 'An error occured while configuring PaperColor'
endtry

hi CursorLine cterm=NONE

augroup cursorline_setting
  autocmd!
  autocmd FileType tagbar setlocal cursorline
augroup END

" }}}
" General: Resize Window --- {{{

" WindowWidth: Resize window to a couple more than longest line
" modified function from:
" https://stackoverflow.com/questions/2075276/longest-line-in-vim
function! ResizeWindowWidth()
  let maxlength   = 0
  let linenumber  = 1
  while linenumber <= line("$")
    exe ":" . linenumber
    let linelength  = virtcol("$")
    if maxlength < linelength
      let maxlength = linelength
    endif
    let linenumber  = linenumber+1
  endwhile
  exe ":vertical resize " . (maxlength + 4)
endfunction

function! ResizeWindowHeight()
  let initial = winnr()

  " this duplicates code but avoids polluting global namespace
  wincmd k
  if winnr() != initial
    exe initial . "wincmd w"
    exe ":1"
    exe "resize " . (line('$') + 1)
    return
  endif

  wincmd j
  if winnr() != initial
    exe initial . "wincmd w"
    exe ":1"
    exe "resize " . (line('$') + 1)
    return
  endif
endfunction

" }}}
" General: Avoid saving 'lcd' --- {{{

augroup stay_no_lcd
  autocmd!
  if exists(':tcd') == 2
    autocmd User BufStaySavePre  if haslocaldir() | let w:lcd = getcwd() | exe 'cd '.fnameescape(getcwd(-1, -1)) | endif
  else
    autocmd User BufStaySavePre  if haslocaldir() | let w:lcd = getcwd() | cd - | cd - | endif
  endif
  autocmd User BufStaySavePost if exists('w:lcd') | execute 'lcd' fnameescape(w:lcd) | unlet w:lcd | endif
augroup END

" --- }}}
"  Plugin: Vim-Plug --- {{{

" Plug update and upgrade
function! _PU()
  exec 'PlugUpdate'
  exec 'PlugUpgrade'
endfunction
command! PU call _PU()

"  }}}
" Plugin: Riv.Vim --- {{{

" Notes (because this Plugin's documentation sucks)
"
" Titles:
"   <C-e>s{0,1,2,3,4,5,6} is the 7 levels of titles
" Lists:
"   Commands:
"     '=' makes list re-number
"     <C-e>l{1,2,3,4,5} sets list to different list types
"   List Types:
"     1) '*'
"     2) '1.'
"     3) 'a.'
"     4) 'A)'
"     5) 'i)'
" Tables:
"   <C-e>tc <- creates a table
"   Insert Mode:
"     typing | creates a new column
"     Header row + new row = <Alt>Enter
"     New row = Just type the correct columns then get into normal mode

let g:riv_disable_folding = 1
let g:riv_global_leader = '<C-E>'
let g:riv_web_browser = 'firefox'
let g:riv_disable_indent = 0
let g:riv_disable_del = 0
let g:riv_auto_format_table = 1
let g:riv_auto_rst2html = 0

let g:instant_rst_localhost_only = 1

" }}}
" Plugin: markdown-preview.vim --- {{{

let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0

" set to 1, the vim will just refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it just can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

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
" Plugin: Preview Compiled Stuff in Viewer --- {{{

function! _Preview()
  if &filetype ==? 'rst'
    exec 'terminal restview %'
    exec "normal \<C-O>"
  elseif &filetype ==? 'markdown'
    " from markdown-preview.vim
    exec 'MarkdownPreview'
  elseif &filetype ==? 'dot'
    " from wmgraphviz.vim
    exec 'GraphvizInteractive'
  elseif &filetype ==? 'plantuml'
    " from plantuml-previewer.vim
    exec 'PlantumlOpen'
  else
    echo 'Preview not supported for this filetype'
  endif
endfunction
command! Preview call _Preview()

" }}}
"  Plugin: NERDTree --- {{{

let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeCaseSensitiveSort = 0
let g:NERDTreeMapJumpFirstChild = '<C-k>'
let g:NERDTreeMapJumpLastChild = '<C-j>'
let g:NERDTreeMapJumpNextSibling = '<C-n>'
let g:NERDTreeMapJumpPrevSibling = '<C-p>'
let g:NERDTreeMapOpenInTab = '<C-t>'
let g:NERDTreeMapOpenInTabSilent = ''
let g:NERDTreeMapOpenSplit = '<C-s>'
let g:NERDTreeMapOpenVSplit = '<C-v>'
let g:NERDTreeShowHidden = 0
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeSortOrder = ['*', '\/$']
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 31
let g:NERDTreeMouseMode = 2
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore=[
      \'venv$[[dir]]',
      \'.venv$[[dir]]',
      \'__pycache__$[[dir]]',
      \'.egg-info$[[dir]]',
      \'node_modules$[[dir]]',
      \'elm-stuff$[[dir]]',
      \'\.aux$[[file]]',
      \'\.toc$[[file]]',
      \'\.pdf$[[file]]',
      \'\.out$[[file]]',
      \'\.o$[[file]]',
      \]

function! _CD(...)  " Like args in Python
  let a:directory = get(a:, 1, expand('%:p:h'))
  execute 'cd ' . a:directory
  if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
    execute 'NERDTreeCWD'
    execute "normal! \<c-w>\<c-p>"
  else
    execute 'NERDTreeCWD'
    execute 'NERDTreeClose'
    execute "normal! \<c-w>="
  endif
endfunction

command! -nargs=? CD call _CD(<f-args>)

function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        \ || &buftype == 'quickfix'
    q
  endif
endfunction

augroup CloseIfOnlyControlWinLeft
  au!
  au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END

let g:NERDTreeIndicatorMapCustom = {
      \ "Modified"  : "!",
      \ "Staged"    : "=",
      \ "Untracked" : "?",
      \ "Renamed"   : "%",
      \ "Unmerged"  : "=",
      \ "Deleted"   : "!",
      \ "Dirty"     : "^",
      \ "Clean"     : "%",
      \ 'Ignored'   : "%",
      \ "Unknown"   : "?"
      \ }

"  }}}
" Plugin: fzf --- {{{

command! -bang -nargs=* Grep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --case-sensitive --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
command! -bang -nargs=* GrepIgnoreCase call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! FZFFilesAvoidNerdtree()
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  " getcwd(-1, -1) tells it to always use the global working directory
  call fzf#run(fzf#wrap({'source': 'fd -c always --type f --hidden --follow --exclude ".git"', 'dir': getcwd(-1, -1)}))
endfunction

function! FZFBuffersAvoidNerdtree()
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  " getcwd(-1, -1) tells it to always use the global working directory
  execute 'Buffers'
endfunction

let g:fzf_height = 12
let g:fzf_action = {
      \ 'ctrl-o': 'edit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-l': function('s:build_quickfix_list'),
      \}

" }}}
" Plugin: Lightline ---------------- {{{

" This is a giant section
" that configures the status line for my vim editing.
" It's super important, so I devote a lot of code to it.
" Most of the functions are ported from the Lightlint documentation

let g:lightline = {}
let g:lightline.active = {}
let g:lightline.inactive = {}
let g:lightline.colorscheme = 'PaperColor'
let g:lightline.mode_map = {
      \   '__' : '-',
      \   'n'  : 'N',
      \   'i'  : 'I',
      \   'R'  : 'R',
      \   'c'  : 'C',
      \   'v'  : 'V',
      \   'V'  : 'V',
      \   '' : 'V',
      \   's'  : 'S',
      \   'S'  : 'S',
      \   '' : 'S',
      \ }
" {
" \   '__' : '-',
" \   'n'  : 'ℕ',
" \   'i'  : 'ⅈ',
" \   'R'  : 'ℛ',
" \   'c'  : 'ℂ',
" \   'v'  : '℣',
" \   'V'  : '℣',
" \   '' : '℣',
" \   's'  : '₷',
" \   'S'  : '₷',
" \   '' : '₷',
" \ }}
" \ )

let g:lightline.component = {
      \ 'mode': '%{lightline#mode()}',
      \ 'absolutepath': '%F',
      \ 'relativepath': '%f',
      \ 'filename': '%t',
      \ 'modified': '%M',
      \ 'bufnum': '%n',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'readonly': '%R',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'fileformat': '%{&ff}',
      \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
      \ 'percent': '%3p%%',
      \ 'percentwin': '%P',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'lineinfo': '%c:%L',
      \ 'line': '%l',
      \ 'column': '%c',
      \ 'close': '%999X X ',
      \ 'winnr': '%{winnr()}' }

let g:lightline.active.left = [
      \ [ 'mode', 'paste', 'spell' ],
      \ [ 'gina', 'readonly', 'filename' ],
      \ [ 'ctrlpmark' ]
      \ ]

let g:lightline.inactive.left = [
      \ [ 'mode', 'paste', 'spell' ],
      \ [ 'gina', 'readonly', 'filename' ],
      \ [ 'ctrlpmark' ]
      \ ]

let g:lightline.active.right = [
      \ [ 'filetype' ],
      \ [ 'fileformat', 'fileencoding' ],
      \ [ 'lineinfo' ]
      \ ]

let g:lightline.inactive.right = [
      \ [ 'filetype' ],
      \ [],
      \ []
      \ ]

let g:lightline.component_function = {
      \ 'gina': 'LightlineGina',
      \ 'filename': 'LightlineFilename',
      \ 'mode': 'LightlineMode'
      \ }

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let cwd = getcwd()
  let fname = substitute(expand("%:p"), l:cwd . "/" , "", "")
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname =~ '__Tagbar__.*' ? '' :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineGina()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler'
      let mark = IfConsole({-> 'Git::'}, {-> '⎇ '})
      let branch = gina#component#repo#branch()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname =~ '__Tagbar__.*' ? 'Tagbar' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

" }}}
" Plugin: Gina --- {{{
" This plugin is awesome
" Just Gina followed by whatever I'd normally type in Git

for gina_cmd in ['branch', 'changes', 'log', 'commit', 'status']
  call gina#custom#command#option(gina_cmd, '--opener', 'tabedit')
endfor

for gina_cmd in ['diff']
  call gina#custom#command#option(gina_cmd, '--opener', 'vsplit')
endfor

call gina#custom#command#option('commit', '--verbose')
call gina#custom#command#option('branch', '--verbose|--all')

let g:gina#command#blame#use_default_mappings = 0
call gina#custom#command#option('blame', '--width', '79')

" Custom mappings for Gina blame buffer
call gina#custom#mapping#nmap(
      \ 'blame', 'c',
      \ '<Plug>(gina-blame-echo)'
      \)
call gina#custom#mapping#nmap(
      \ 'blame', '<CR>',
      \ '<Plug>(gina-blame-open)'
      \)
call gina#custom#mapping#nmap(
      \ 'blame', '<c-i>',
      \ '<Plug>(gina-blame-open)'
      \)
call gina#custom#mapping#nmap(
      \ 'blame', '<Backspace>',
      \ '<Plug>(gina-blame-back)'
      \)
call gina#custom#mapping#nmap(
      \ 'blame', '<c-o>',
      \ '<Plug>(gina-blame-back)'
      \)

let g:gina#command#blame#formatter#format = '%in|%ti|%au|%su'
let g:gina#command#blame#formatter#timestamp_months = 0
let g:gina#command#blame#formatter#timestamp_format1 = "%Y-%m-%d"
let g:gina#command#blame#formatter#timestamp_format2 = "%Y-%m-%d"

function! _Gblame()
  let current_file = expand('%:t')
  execute 'Gina blame'
endfunction

command! Gblame call _Gblame()

" }}}
"  Plugin: Tagbar ------ {{{

let g:tagbar_map_showproto = '`'
let g:tagbar_show_linenumbers = -1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1
let g:tagbar_sort = 0  " order by order in sort file
let g:tagbar_case_insensitive = 1
let g:tagbar_width = 37
let g:tagbar_silent = 1
let g:tagbar_foldlevel = 0
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
let g:tagbar_type_rst = {
      \ 'ctagstype': 'rst',
      \ 'ctagsbin' : '~/src/lib/rst2ctags/rst2ctags.py',
      \ 'ctagsargs' : '-f - --sort=yes',
      \ 'kinds' : [
      \ 's:sections',
      \ 'i:images'
      \ ],
      \ 'sro' : '|',
      \ 'kind2scope' : {
      \ 's' : 'section',
      \ },
      \ 'sort': 0,
      \ }

"  }}}
"  Plugin: Startify ------------- {{{

let g:startify_list_order = []
let g:startify_fortune_use_unicode = 1
let g:startify_enable_special = 1
let g:startify_custom_header = []
let g:startify_custom_footer = [
      \ '                _______.     ___      .___  ___.',
      \ '               /       |    /   \     |   \/   |',
      \ '              |   (----`   /  ^  \    |  \  /  |',
      \ '               \   \      /  /_\  \   |  |\/|  |',
      \ '           .----)   |    /  _____  \  |  |  |  |',
      \ '           |_______/    /__/     \__\ |__|  |__|',
      \ ' ____    __    ____      ___      .______           _______.',
      \ ' \   \  /  \  /   /     /   \     |   _  \         /       |',
      \ '  \   \/    \/   /     /  ^  \    |  |_)  |       |   (----`',
      \ '   \            /     /  /_\  \   |      /         \   \',
      \ '    \    /\    /     /  _____  \  |  |\  \----..----)   |',
      \ '     \__/  \__/     /__/     \__\ | _| `._____||_______/',
      \ '',
      \ '                                            .',
      \ '                                  .-o',
      \ '                     .           /  |',
      \ '            .                 . /   |   .',
      \ '                               /    |',
      \ '                      .       /     |',
      \ '      .                      /      /         .',
      \ '                 .          /    _./   .',
      \ '                       _.---~-.=:_',
      \ '                      (_.-=() <~`-`-.',
      \ '                     _/ _() ~`-==-._,>',
      \ '             ..--====--` `~-._.__()',
      \ '         o===``~~             |__()',
      \ '                    .         \   |             .',
      \ '                               \  \    .',
      \ '                                \  \',
      \ '            .                    \  \   Sienar Fleet Systems',
      \ '                     .            \  \  Lambda-class',
      \ '                                   \_ \ Imperial Shuttle',
      \ '                           LS        ~o',
      \ '',
      \] + map(startify#fortune#boxed(), {idx, val -> ' ' . val})

"  }}}
"  Plugin: VimTex --- {{{

let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:tex_flavor = 'latex'
let g:vimtex_imaps_enabled = 0
let g:vimtex_doc_handlers = ['MyVimTexDocHandler']
function! MyVimTexDocHandler(context)
  " Function called with using :VimtexDocPackage
  " to pull up package documentation
  call vimtex#doc#make_selection(a:context)
  if !empty(a:context.selected)
    execute '!texdoc' a:context.selected '&'
  endif
  return 1
endfunction

"  }}}
"  Plugin: AutoPairs --- {{{

" AutoPairs:
" unmap CR due to incompatibility with clang-complete
let g:AutoPairsMapCR = 0
let g:AutoPairs = {
      \ '(':')',
      \ '[':']',
      \ '{':'}',
      \ "'":"'",
      \ '"':'"',
      \ '`':'`'
      \ }
augroup autopairs_filetype_overrides
  autocmd FileType markdown let b:AutoPairs = {
        \ '(':')',
        \ '[':']',
        \ '{':'}',
        \ "'":"'",
        \ '"':'"',
        \ '`':'`',
        \ '"""': '"""',
        \ "'''": "'''",
        \ '```': '```'
        \ }
  autocmd FileType plantuml let b:AutoPairs = {
        \ '(':')',
        \ '[':']',
        \ '{':'}',
        \ '"':'"',
        \ '`':'`'
        \ }
  autocmd FileType python let b:AutoPairs = {
        \ '(':')',
        \ '[':']',
        \ '{':'}',
        \ "'":"'",
        \ '"':'"',
        \ '`':'`',
        \ '"""': '"""',
        \ "'''": "'''"
        \ }
  autocmd FileType rust let b:AutoPairs = {
        \ '(':')',
        \ '[':']',
        \ '{':'}',
        \ '"':'"',
        \ '`':'`'
        \ }
  autocmd FileType tex let b:AutoPairs = {
        \ '(':')',
        \ '[':']',
        \ '{':'}',
        \ '`': "'"
        \ }
  autocmd FileType vim let b:AutoPairs = {
        \ '(':')',
        \ '[':']',
        \ '{':'}',
        \ "'":"'",
        \ '`':'`'
        \ }
augroup END

"  }}}
"  Plugin: Sandwich --- {{{

" LatexNotes:
"   textobject:
"     replace inner text of `text' with cisl'
"     if auto detection of nearest surrounding is fine cib
"   add to text:
"     saiwl' single apostrophes to get `text'
"     The pattern of the command is sa{motion/textobject}{surrounding}
"     means invoke operator add  surrounding on inner word and surround type
"     is latex single quote.
"   delete:
"     with sdl' or with sdb
"   change:
"     with srl'l" or with srbl"
let g:textobj_sandwich_no_default_key_mappings = 1

" Below mappings address the issue raised here:
" https://github.com/machakann/vim-sandwich/issues/62
xmap ib <Plug>(textobj-sandwich-auto-i)
omap ib <Plug>(textobj-sandwich-auto-i)
xmap ab <Plug>(textobj-sandwich-auto-a)
omap ab <Plug>(textobj-sandwich-auto-a)

xmap iq <Plug>(textobj-sandwich-query-i)
omap iq <Plug>(textobj-sandwich-query-i)
xmap aq <Plug>(textobj-sandwich-query-a)
omap aq <Plug>(textobj-sandwich-query-a)

"  }}}
"  Plugin: Ledger --- {{{

let g:ledger_maxwidth = 80
let g:ledger_fillstring = ' - -'
let g:ledger_fold_blanks = 2

" Code formatter function for the ledger filetype
" Depends on ledger/vim-ledger
function! _LedgerFmt()
  let filepath = expand('%')
  let command = 'ledger -f ' . filepath . ' print --sort "date, amount"'
  call _UDFCodeFormat('LedgerFmt', command, 0)
endfunction

augroup ledger_settings
  autocmd!
  autocmd FileType ledger command! -buffer LedgerFmt call _LedgerFmt()
  autocmd FileType ledger noremap { ?^\d<CR>
  autocmd FileType ledger noremap } /^\d<CR>
augroup END

"  }}}
"  Plugin: Goyo --- {{{

" Set width a bit wider to account for line numbers
let g:goyo_width = 84

function! s:goyo_enter()
  let b:goyo_is_on = 1
  setlocal number relativenumber
endfunction

function! s:goyo_leave()
  let b:goyo_is_on = 0
  setlocal number relativenumber
endfunction

function! GoyoToggleCustom()
  if !exists('b:goyo_is_on')
    let b:goyo_is_on = 0
  endif

  if b:goyo_is_on
    execute 'NumbersEnable'
    setlocal nonumber norelativenumber
  else
    execute 'NumbersDisable'
  endif

  execute 'Goyo'
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"  }}}
"  Plugin: AutoCompletion config and key remappings ------------ {{{

" NOTE: General remappings
" 1) go to file containing definition: <C-]>
" 2) Return from file (relies on tag stack): <C-O>
" 3) Print the documentation of something under the cursor: <leader>gd

" LanguageClientServer: configure it for relevant languages
set runtimepath+=$HOME/.vim/plugged/LanguageClient-neovim
let g:LanguageClient_serverCommands = {
      \ 'haskell': ['stack', 'exec', 'hie-wrapper'],
      \ 'ruby': ['solargraph', 'stdio']
      \ }
let g:LanguageClient_autoStart = 1
let g:LanguageClient_hoverPreview = 'auto'
let g:LanguageClient_diagnosticsEnable = 0
function! ConfigureLanguageClient()
  nnoremap <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
  nnoremap <buffer> <leader>sd :call LanguageClient#textDocument_hover()<CR>
  nnoremap <buffer> <leader>sr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <buffer> <leader>su :call LanguageClient#textDocument_references()<CR>
  setlocal omnifunc=LanguageClient#complete
endfunction

augroup langserverLanguages
  autocmd FileType haskell,ruby call ConfigureLanguageClient()
augroup END

" VimScript:
" Autocompletion and show definition is built in to Vim
" Set the same shortcuts as usual to find them
augroup vimscript_complete
  autocmd!
  autocmd FileType vim nnoremap <buffer> <C-]> yiw:help <C-r>"<CR>
  autocmd FileType vim inoremap <buffer> <C-@> <C-x><C-v>
  autocmd FileType vim inoremap <buffer> <C-space> <C-x><C-v>
augroup END

" Python:
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0
let g:jedi#auto_close_doc = 0
let g:jedi#smart_auto_mappings = 0

" mappings
" auto_vim_configuration creates space between where vim is opened and
" closed in my bash terminal. This is annoying, so I disable and manually
" configure. See 'set completeopt' in my global config for my settings
let g:jedi#auto_vim_configuration = 0
let g:jedi#goto_command = "<C-]>"
let g:jedi#documentation_command = "<leader>sd"
let g:jedi#usages_command = "<leader>su"
let g:jedi#rename_command = "<leader>sr"

" Javascript:
let g:tern#command = ["npx", "tern"]
let g:tern_show_argument_hints = 'on_move'
let g:tern_show_signature_in_pum = 1
augroup javascript_complete
  autocmd!
  autocmd FileType javascript nnoremap <buffer> <C-]> :TernDef<CR>
  autocmd FileType javascript nnoremap <buffer> <leader>gd :TernDoc<CR>
augroup END

" Elm:
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 0
augroup elm_complete
  autocmd!
  autocmd FileType elm nnoremap <buffer> <C-]> :ElmShowDocs<CR>
augroup END

" C_CPP:
" Jumping back defaults to <C-O> or <C-T> (in is <C-I> per usual)
" Defaults to <C-]> for goto definition
" Additionally, jumping to Header file under cursor: gd
let g:clang_library_path = '/usr/lib/llvm-6.0/lib'
let g:clang_auto_user_options = 'compile_commands.json, path, .clang_complete'
let g:clang_complete_auto = 0
let g:clang_complete_macros = 1
let g:clang_jumpto_declaration_key = "<C-]>"

" Rust:
" rustup install racer
let g:racer_cmd = $HOME . '/.cargo/bin/racer'
let g:racer_experimental_completer = 1
augroup rust_complete
  autocmd!
  " needs to be nmap; does not work with nnoremap
  autocmd FileType rust nmap <buffer> <C-]> <Plug>(rust-def)
  autocmd FileType rust nmap <leader>sd <Plug>(rust-doc)
augroup END

" Writing: writing document
" currently only supports markdown
" jump to word definition for several text editors (including markdown)
augroup writing_complete
  autocmd FileType markdown,tex,rst,txt nnoremap <buffer> <C-]> :Def <cword><CR>
augroup END

" Terraform
augroup terraform_complete
  autocmd FileType terraform setlocal omnifunc=terraformcomplete#Complete
augroup END

"  }}}
" Plugin: vim-filetype-formatter and autoformatting --- {{{

let g:vim_filetype_formatter_verbose = 0
let g:vim_filetype_formatter_commands = {
      \ 'python': 'yapf',
      \ 'rust': 'rustfmt',
      \ 'terraform': 'terraform fmt -',
      \ 'json': 'python3 -c "import json, sys; print(json.dumps(json.load(sys.stdin), indent=2))"',
      \}

" }}}
"  Plugin: Miscellaneous global var config ------------ {{{

" UndoTree:
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

" QFEnter:
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-s>']
let g:qfenter_keymap.topen = ['<C-t>']
" do not copy quickfix when opened in new tab
let g:qfenter_enable_autoquickfix = 0
" automatically move QuickFix window to fill entire bottom screen
augroup QuickFix
  autocmd FileType qf wincmd J
augroup END

" WinResize:
let g:winresizer_start_key = '<C-\>'
let g:winresizer_vert_resize = 1
let g:winresizer_horiz_resize = 1

" Haskell: 'neovimhaskell/haskell-vim'
let g:haskell_enable_quantification = 1   " to highlight `forall`
let g:haskell_enable_recursivedo = 1      " to highlight `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to highlight `proc`
let g:haskell_enable_pattern_synonyms = 1 " to highlight `pattern`
let g:haskell_enable_typeroles = 1        " to highlight type roles
let g:haskell_enable_static_pointers = 1  " to highlight `static`

" Python: highlighting
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

" Json: highlighting
let g:vim_json_syntax_conceal = 0

" Ragtag: on every filetype
let g:ragtag_global_maps = 1

" VimJavascript:
let g:javascript_plugin_flow = 1

" JSX: for .js files in addition to .jsx
let g:jsx_ext_required = 0

" JsDoc:
let g:jsdoc_enable_es6 = 1

" IndentLines:
let g:indentLine_enabled = 0  " indentlines disabled by default

" VimMarkdown:
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" BulletsVim:
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" Numbersvim: override default plugin settings
let g:numbers_exclude = ['startify', 'gundo', 'vimshell', 'gina-commit',
      \ 'gitcommit']

" VimMarkdownComposer: override defaults
let g:markdown_composer_open_browser = 0

" RequirementsVim: filetype detection (begin with requirements)
let g:requirements#detect_filename_pattern = 'requirements.*\.txt'

" QuickScope: great plugin helping with f and t
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 10000

" Go: random stuff
let g:go_version_warning = 0

" ChooseWin: options
let g:choosewin_overlay_enable = 1

" Colorizer: css color code highlighting
let g:colorizer_auto_filetype='css,html'

" HexMode: configure hex editing
" relevant command: Hexmode
let g:hexmode_patterns = '*.bin,*.exe,*.dat,*.o'
let g:hexmode_xxd_options = '-g 2'

"  }}}
" General: Clean Unicode --- {{{

function! CleanUnicode()
  " Replace unicode symbols with cleaned versions
  silent! %s/”/"/g
  silent! %s/“/"/g
  silent! %s/’/'/g
  silent! %s/‘/'/g
endfunction()
command! CleanUnicode call CleanUnicode()

" }}}
" General: Neovim Terminal --- {{{

function! s:openTerm(view_type)
  exec a:view_type
  terminal
  setlocal nonumber nornu
  startinsert
endfunction

command! Term call s:openTerm('split')
command! Termv call s:openTerm('vsplit')
command! Vtert call s:openTerm('tabnew')

" }}}
" General: Number width to 80 (including special characters)---- {{{

function! ResizeTo80()
  let cols = 80
  if &number ==# 1 || &relativenumber ==# 1
    let numberwidth = float2nr(log10(line("$"))) + 2
    let columns = &numberwidth + cols
    execute 'vertical res ' columns
  else
    execute 'vertical res ' cols
  endif
endfunction

" }}}
" General: Key remappings (includes Plugins) ----------------------- {{{

" Escape:
" Make escape also clear highlighting
nnoremap <silent> <esc> :noh<return><esc>

" ScrollDropdown:
" Enable scrolling dropdown menu with the mouse
" Additionally, make clicking select the highlighted item
inoremap <expr> <ScrollWheelUp> pumvisible() ? "<C-p>" : "<Esc><ScrollWheelUp>"
inoremap <expr> <ScrollWheelDown> pumvisible() ? "<C-n>" : "<Esc><ScrollWheelDown>"
inoremap <expr> <LeftMouse> pumvisible() ? "<CR><Backspace>" : "<Esc><LeftMouse>"

" InsertModeHelpers:
" Insert one line above after enter (useful for ``` in markdown)
" Key code = Alt+Enter
inoremap <M-CR> <CR><C-o>O

" Omnicompletion:
" <C-@> is signal sent by terminal when pressing <C-Space>
" Need to include <C-Space> as well for neovim sometimes
inoremap <C-@> <C-x><C-o>
inoremap <C-space> <C-x><C-o>

" EnglishWordCompletion:
" Look up words in a dictionary
" <C-x><C-k> = dictionary completion

" Exit: Preview and Help && QuickFix and Location List
inoremap <silent> <C-c> <Esc>:pclose <BAR> helpclose <BAR> cclose <BAR> lclose<CR>a
nnoremap <silent> <C-c> :pclose <BAR> helpclose <BAR> cclose <BAR> lclose<CR>

" MoveVisual: up and down visually only if count is specified before
" Otherwise, you want to move up lines numerically
" e.g. ignoring wrapped lines
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" MoveTabs: moving forward, backward, and to number with vim tabs
nnoremap <silent> L gt
nnoremap <silent> H gT
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt

" Substitute: file replace word under cursor
" Places user in the vim command line
vnoremap sc y:%s/<C-R>0//gc<C-F>$hhi

" IndentComma: placing commas one line down
" usable with repeat operator '.'
nnoremap <silent> <Plug>NewLineComma f,wi<CR><Esc>
      \:call repeat#set("\<Plug>NewLineComma")<CR>
nmap <leader><CR> <Plug>NewLineComma

" BuffersAndWindows:
" Move from one window to another
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
" Scroll screen up, down, left, and right
" left: zh, right: zl
nnoremap <silent> K <c-e>
nnoremap <silent> J <c-y>
" Move cursor to top, bottom, and middle of screen
nnoremap <silent> gJ L
nnoremap <silent> gK H
nnoremap <silent> gM M

" InsertModeDeletion:
" Delete character under cursor in insert mode
inoremap <C-l> <Del>

" Jinja2Toggle:
" The following mapping toggles jinja2 for any filetype
function! Jinja2Toggle()
  let jinja2 = '.jinja2'
  let jinja2_pattern = '\' . jinja2
  if matchstr(&ft, jinja2_pattern) == ""
    let new_filetype = &ft . jinja2
  else
    let new_filetype = substitute(&ft, jinja2_pattern, "", "")
  endif
  execute "set filetype=" . new_filetype
endfunction
nnoremap <silent> <leader>j :call Jinja2Toggle()<CR>

" ToggleRelativeNumber: uses custom functions
nnoremap <silent><leader>r :NumbersToggle<CR>

" TogglePluginWindows:
nnoremap <silent> <space>j :NERDTreeToggle<CR><c-w>=
nnoremap <silent> <space>l :TagbarToggle <CR>
nnoremap <silent> <space>u :UndotreeToggle<CR>

" NERDTree: Jump to current file
nnoremap <silent> <space>k :NERDTreeFind<cr><C-w>w

" Choosewin: (just like tmux)
nnoremap <leader>q :ChooseWin<CR>

" Goyo
nnoremap <leader><leader>g :call GoyoToggleCustom()<cr>

" IndentLines: toggle if indent lines is visible
nnoremap <silent> <leader>i :IndentLinesToggle<CR>

" ResizeWindow: up and down; relies on custom functions
nnoremap <silent> <leader><leader>h mz:call ResizeWindowHeight()<CR>`z
nnoremap <silent> <leader><leader>w mz:call ResizeWindowWidth()<CR>`z

" AutoPairs:
imap <silent><CR> <CR><Plug>AutoPairsReturn

" FZF: create shortcuts for finding stuff
nnoremap <silent> <C-P> :call FZFFilesAvoidNerdtree()<CR>
nnoremap <silent> <C-B> :call FZFBuffersAvoidNerdtree()<CR>
nnoremap <C-n> yiw:Grep <C-r>"<CR>
vnoremap <C-n> y:Grep <C-r>"<CR>
nnoremap <leader><C-n> yiw:GrepIgnoreCase <C-r>"<CR>
vnoremap <leader><C-n> y:GrepIgnoreCase <C-r>"<CR>

" DeleteHiddenBuffers: shortcut to make this easier
" Note: weird stuff happens if you mess this up
nnoremap <leader>d :DeleteHiddenBuffers<CR>

" Jumping to header file
nnoremap gh :call CurtineIncSw()<CR>

" Open split for writing (80 character window width for wrap)
nnoremap <silent> <leader>v :call ResizeTo80()<CR>

" MouseCopy: system copy mouse characteristics
vmap <RightMouse> <Plug>SystemCopy<CR>
imap <MiddleMouse> <Plug>SystemPaste<CR>

" SearchBackward: remap comma to single quote
nnoremap ' ,

" FiletypeFormat: remap leader f to do filetype formatting
nnoremap <leader>f :FiletypeFormat<cr>
augroup language_specific_file_beauty
  autocmd FileType ledger nnoremap <buffer> <leader>f :%LedgerAlign<cr>
augroup END

" }}}
" General: Macro repeater ---- {{{

" Allow '.' to repeat macros. Finally!
" Taken from here:
" https://vi.stackexchange.com/questions/11210/can-i-repeat-a-macro-with-the-dot-operator
" SR took it from GitHub: ckarnell/Antonys-macro-repeater
"
" When . repeats g@, repeat the last macro.
fun! AtRepeat(_)
  " If no count is supplied use the one saved in s:atcount.
  " Otherwise save the new count in s:atcount, so it will be
  " applied to repeats.
  let s:atcount = v:count ? v:count : s:atcount
  " feedkeys() rather than :normal allows finishing in Insert
  " mode, should the macro do that. @@ is remapped, so 'opfunc'
  " will be correct, even if the macro changes it.
  call feedkeys(s:atcount.'@@')
endfun

fun! AtSetRepeat(_)
  set operatorfunc=AtRepeat
endfun

" Called by g@ being invoked directly for the first time. Sets
" 'opfunc' ready for repeats with . by calling AtSetRepeat().
fun! AtInit()
  " Make sure setting 'opfunc' happens here, after initial playback
  " of the macro recording, in case 'opfunc' is set there.
  set operatorfunc=AtSetRepeat
  return 'g@l'
endfun

" Enable calling a function within the mapping for @
nnoremap <expr> <plug>@init AtInit()
" A macro could, albeit unusually, end in Insert mode.
inoremap <expr> <plug>@init "\<c-o>".AtInit()

fun! AtReg()
  let s:atcount = v:count1
  let l:c = nr2char(getchar())
  return '@'.l:c."\<plug>@init"
endfun


" The following code allows pressing . immediately after
" recording a macro to play it back.
nmap <expr> @ AtReg()
fun! QRepeat(_)
  call feedkeys('@'.s:qreg)
endfun

fun! QSetRepeat(_)
  set operatorfunc=QRepeat
endfun

fun! QStop()
  set operatorfunc=QSetRepeat
  return 'g@l'
endfun

nnoremap <expr> <plug>qstop QStop()
inoremap <expr> <plug>qstop "\<c-o>".QStop()

let s:qrec = 0
fun! QStart()
  if s:qrec == 1
    let s:qrec = 0
    return "q\<plug>qstop"
  endif
  let s:qreg = nr2char(getchar())
  if s:qreg =~# '[0-9a-zA-Z"]'
    let s:qrec = 1
  endif
  return 'q'.s:qreg
endfun

" Finally, remap q! Recursion is actually useful here I think,
" otherwise I would use 'nnoremap'.
nmap <expr> q QStart()

" }}}
" General: Command abbreviations ------------------------ {{{

" Execute current file
command! Run !./%

" Fix highlighting
command! FixHighlight syntax sync fromstart

" }}}
" General: Global Config + Cleanup ------------------ {{{
" commands that need to run at the end of my vimrc

" disable unsafe commands in your project-specific .vimrc files
" This will prevent :autocmd, shell and write commands from being
" run inside project-specific .vimrc files unless they’re owned by you.
set secure

" Lightline: specifics for Lightline
set laststatus=2
set ttimeoutlen=50
set noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" CursorLine:
" insert mode - line
let &t_SI .= "\<Esc>[5 q"
"replace mode - underline
let &t_SR .= "\<Esc>[4 q"
"common - block
let &t_EI .= "\<Esc>[3 q"
" Turn off GUI cursor changes in console mode (tty)
call IfConsole({-> execute('set guicursor=')}, {-> 0})

" Configure updatetime
" This is the amount of time vim waits to do something after you stop
" acting. Default is 4000, this works well for my fast system
set updatetime=750

" Update path for Linux-specific libraries
set path+=/usr/include/x86_64-linux-gnu/

" }}}
