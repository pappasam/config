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
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree.git'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'vim-scripts/EasyGrep'
Plugin 'derekwyatt/vim-scala'
Plugin 'vimoutliner/vimoutliner'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround' " Good for XMl editing
Plugin 'tpope/vim-ragtag' " Extends vim-surround
Plugin 'mattn/emmet-vim.git' " Adds custom something to vim; read more later
Plugin 'kien/rainbow_parentheses.vim' " Add matching parentheses
Plugin 'elzr/vim-json' " JSON support
Plugin 'bronson/vim-trailing-whitespace' " Trailing whitespace
Plugin 'tomasr/molokai' " Color theme; best background for vim
Plugin 'autowitch/hive.vim'
call vundle#end()

filetype plugin indent on
" }}}
" Rainbow Parentheses ------------ {{{
augroup rainbow_parentheses
	autocmd!
	autocmd VimEnter * RainbowParenthesesToggle
	autocmd Syntax * RainbowParenthesesLoadRound
	autocmd Syntax * RainbowParenthesesLoadSquare
	autocmd Syntax * RainbowParenthesesLoadBraces
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
" HTML Files --------------- {{{
augroup filetype_html
	autocmd!
	autocmd FileType html nnoremap <buffer> <localheader>f Vatzf
augroup END
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
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun
augroup allfiles_trailingspace
	autocmd!
	autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
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
" General Widths ------------- {{{
augroup tabwidth_sr
    autocmd!
    autocmd Filetype * :setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
augroup END
" }}}
" Outline Files------------------ {{{
augroup outline_sr
    autocmd!
    autocmd BufRead,BufNewFile *.otl :setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
augroup END
" }}}
" Hive ----------------------- {{{
augroup hive_sr
    autocmd!
    autocmd BufNewFile,BufRead *.hql set filetype=hive
    autocmd BufNewFile,BufRead *.q set filetype=hive
augroup END
" }}}
