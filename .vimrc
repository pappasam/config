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
" }}}
" Vundle --------------------- {{{
" Turn off important incompatibilities with vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/

call vundle#begin()

" Basics
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree.git'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'vim-scripts/EasyGrep'

" Basic coloring
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'junegunn/rainbow_parentheses.vim'
Plugin 'tomasr/molokai'

" Utils
Plugin 'tpope/vim-commentary'
Plugin 'mattn/emmet-vim.git'

" Language-specific syntax
Plugin 'derekwyatt/vim-scala'
Plugin 'wting/rust.vim'
Plugin 'hdima/python-syntax'
Plugin 'autowitch/hive.vim'
Plugin 'elzr/vim-json'
Plugin 'vimoutliner/vimoutliner'
Plugin 'cespare/vim-toml'
Plugin 'Glench/Vim-Jinja2-Syntax'

" Web Development
Plugin 'edsono/vim-matchit'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-ragtag'

call vundle#end()

filetype plugin indent on
" }}}
" Filetypes ------------ {{{
augroup filetype_recognition
    autocmd!
    autocmd BufNewFile,BufRead *.html set filetype=html
    autocmd BufNewFile,BufRead *.md,*.markdown set filetype=markdown
    autocmd BufNewFile,BufRead *.hql,*.q set filetype=hive
augroup END
" }}}
" Rainbow Parentheses ------------ {{{
let g:rainbow#pairs = [['(',')'], ['[', ']'], ['{','}']]
augroup rainbow_parentheses
    " Must list all languages that experience rainbow parentheses below
    " Not explicitly listing here causes conflicts with other languages
    " Trust me, this is the best solution I could find
    autocmd!
    autocmd FileType python,javascript RainbowParentheses
    autocmd FileType list,closure,scheme RainbowParentheses
augroup END
" }}}
" General Key remappings ----------------------- {{{
" Enable movement within block of text
nnoremap k gk
nnoremap j gj
nnoremap 0 g0
nnoremap $ g$
" Autogenerate Parentheses, braces, and brackets
inoremap (<CR> (<CR>)<Esc>O
inoremap {<CR>	{<CR>}<Esc>O
inoremap [<CR>	[<CR>]<Esc>O
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
" Access vimrc ------------------- {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :so $MYVIMRC<cr>
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
" Tabs and Windows ----------------- {{{
" Open new tab
nnoremap ;l :tabe . <ENTER>
nnoremap ;j :tabp <ENTER>
nnoremap ;k :tabn <ENTER>
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
" Nerdtree --------------- {{{
silent! nnoremap <C-p> :NERDTreeToggle<CR>
silent! noremap <F2> :NERDTreeToggle<CR>
silent! noremap <F3> :NERDTreeFind<CR>
let g:NERDTreeToggle="<F2>"
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"
set wildignore+=*/target/*
" }}}
" Indentation ------------- {{{
augroup indentation_sr
    autocmd!
    autocmd Filetype * setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
    autocmd Filetype dot setlocal autoindent cindent
augroup END
" }}}
" Tabs, not spaces------------------ {{{
augroup TabsNotSpaces
    autocmd!
    autocmd BufRead,BufNewFile *.otl :setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
    autocmd BufRead,BufNewFile *GNUmakefile,*makefile,*Makefile :setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
augroup END
" }}}
" Python------------------ {{{
let python_highlight_all = 1
" }}}
" Writing ------------------ {{{
augroup writing
    autocmd!
    autocmd FileType markdown,html :setlocal wrap linebreak nolist
    autocmd FileType markdown,html :setlocal colorcolumn=0
augroup END
" }}}
