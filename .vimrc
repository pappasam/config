" Leader mappings -------------------- {{{
let mapleader = ","
let maplocalleader = "\\"
" }}}
" Display settings ------------ {{{
set wrap
" Status bar
set statusline=%F
set statusline+=%=
set statusline+=%l
set statusline+=/
set statusline+=%L

" Set column to light grey at 80 characters
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

" Set hybrid line numbers
set relativenumber
set number
" }}}
" Vim-Plug Auto Load ----------------- {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}
" Plugins --------------------- {{{
call plug#begin('~/.vim/plugged')

" Basics
Plug 'jeetsukumaran/vim-buffergator'
Plug 'dkprice/vim-easygrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Static checking
Plug 'scrooloose/syntastic'

" Requirements for vimdeck
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-scripts/ingo-library'

" Rainbow
Plug 'junegunn/rainbow_parentheses.vim'

" Basic coloring
Plug 'bronson/vim-trailing-whitespace'
Plug 'tomasr/molokai'

" Utils
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'xolox/vim-misc'
Plug 'jiangmiao/auto-pairs'

" C-syntax
Plug 'justinmk/vim-syntax-extra', {'for': 'C'}

" Language-specific syntax
Plug 'derekwyatt/vim-scala',
Plug 'wting/rust.vim'
Plug 'hdima/python-syntax', {'for': 'python'}
Plug 'autowitch/hive.vim'
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'vimoutliner/vimoutliner'
Plug 'cespare/vim-toml'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'plasticboy/vim-markdown'
Plug 'ElmCast/elm-vim'
Plug 'mopp/rik_octave.vim'

" Web Development - Javascript
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
Plug 'othree/yajs.vim', {'for': 'javascript'}
Plug 'mxw/vim-jsx'
Plug 'groenewege/vim-less'

" Web Development - General
Plug 'mattn/emmet-vim'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'pappasam/vim-ragtag'

call plug#end()
" }}}
" Configure syntastic ----------- {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = {'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': []}
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checkers = ['flake8', 'pyflakes', 'pylint']
let g:syntastic_python_flake8_args = "--ignore=E123,E124,E126,E128,E302,E731"

nnoremap <leader>sc :write<CR> :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>
" }}}
" Configure Rainbow ------------- {{{
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']']]
augroup rainbow_settings
  " Section to turn on rainbow parentheses
  autocmd!
  autocmd FileType * RainbowParentheses
augroup END
" }}}
" Configure Airline ----------- {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
set laststatus=2
set ttimeoutlen=50
set noshowmode
" }}}
" Configure EasyGrep ---------- {{{

" Track the current file extension
let g:EasyGrepMode = 2

" User regular Grep, not VimGrep
let gEasyGrepCommand = 1

" Root the search at the git repo
let g:EasyGrepRoot = 'repository'

" Search the escaped string (eg, non-regex)
let g:EasyGrepPatternType = 'fixed'

" Enable recursive search by default
let g:EasyGrepRecursive = 1

" Ignore certain directories
let g:EasyGrepFilesToExclude = '*?/venv/*,' .
      \ '*?/__pycache__/*,' .
      \ '*?/node_modules/*,' .
      \ '*?/bin/*,' .
      \ '*?/target/*,'

" }}}
" Configure Auto Pairs ----------- {{{
" How to insert parens purely
" There are 3 ways
" 1. use Ctrl-V ) to insert paren without trigger the plugin.
" 2. use Alt-P to turn off the plugin.
" 3. use DEL or <C-O>x to delete the character insert by plugin.
" --- }}}
" Configure Additional Plugin constants ------------ {{{

" Set the javascript libraries that need syntax highlighting
let g:used_javascript_libs = 'jquery,requirejs,react'

" Python highlighting
let python_highlight_all = 1

"  }}}
" Filetypes ------------ {{{
augroup filetype_recognition
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.markdown set filetype=markdown
    autocmd BufNewFile,BufRead *.hql,*.q set filetype=hive
    autocmd BufNewFile,BufRead *.config set filetype=yaml
    autocmd BufNewFile,BufRead *.bowerrc set filetype=json
    au BufNewFile,BufRead *.handlebars set filetype=html
augroup END
" }}}
" General Key remappings ----------------------- {{{
" Enable movement within block of text
nnoremap k gk
nnoremap j gj
nnoremap 0 g0
nnoremap $ g$
" Remap operators for doing things inserting in previous and next parentheses
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap il[ :<c-u>normal! F]vi[<cr>
" Move line up and down with hyphen key
nnoremap - ddp
nnoremap _ ddkP
" Remap H and L to beginning and end of line
nnoremap H 0
nnoremap L $
" }}}
" Vimscript file settings ------------------- {{{
augroup filetype_vim
	autocmd!
	autocmd BufWritePost *vimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
	autocmd FileType vim setlocal foldmethod=marker
	autocmd FileType vim setlocal foldlevelstart=0
augroup END
" }}}
" Surround text ------------------ {{{
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" }}}
" Buffers and Windows ----------------- {{{
" Open new buffer, scroll buffers
nnoremap ;l :e . <ENTER>
nnoremap ;j :bp <ENTER>
nnoremap ;k :bn <ENTER>
" Change change window thorough Control + directional movement
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
" }}}
" Syntax coloring ---------------- {{{
try
    set t_Co=256 " says terminal has 256 colors
    let g:molokai_original = 1
    let g:rehash256 = 1
    colorscheme molokai
catch
endtry
" }}}
" Trailing whitespace ------------- {{{
function! <SID>StripTrailingWhitespaces()
    if exists('b:noStripWhitespace')
        return
    endif
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
augroup allfiles_trailingspace
    autocmd!
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
    autocmd FileType markdown let b:noStripWhitespace=1
augroup END
" }}}
" Indentation ------------- {{{

" Note -> apparently BufRead, BufNewFile trumps Filetype
" Eg, if BufRead,BufNewFile * ignores any Filetype overwrites
" This is why default settings are chosed with Filetype *
augroup indentation_sr
    autocmd!
    autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
    autocmd Filetype python,c,elm setlocal shiftwidth=4 softtabstop=4 tabstop=8
    autocmd Filetype dot setlocal autoindent cindent
    autocmd BufRead,BufNewFile *.otl,*GNUmakefile,*makefile,*Makefile,*.tsv
          \ setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
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
