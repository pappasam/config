" Commands {{{

command! P lua vim.pack.update()

command! C call s:color()
function! s:color()
  set lazyredraw
  try
    only
    cd ~/.local/share/nvim/site/pack/core/opt/papercolor-theme-slim
    edit ./colors/PaperColorSlim.vim
    setlocal cursorlineopt=both
    vsplit
    edit ./colors/PaperColorSlimLight.vim
    wincmd h
    normal! M
    CS
  finally
    set nolazyredraw
  endtry
endfunction

command! CS call s:color_sync()
function! s:color_sync() " 'scrollbind' does not work with colorizer
  let current_win = winnr()
  execute 'windo ' .. line('.')
  windo normal! z.
  redraw
  execute current_win .. 'wincmd w'
  ColorizerReloadAllBuffers
endfunction

command! Fit call s:resize_window_width()
function! s:resize_window_width()
  set lazyredraw
  try
    let max_length = max(map(range(1, line('$')), "virtcol([v:val, '$'])"))
    let leading_space = getwininfo(win_getid())[0].textoff
    normal! ma
    execute ':vertical resize ' .. (max_length + leading_space)
    normal! `a
  finally
    set nolazyredraw
  endtry
endfunction

command! F call s:focuswriting()
function! s:focuswriting()
  set lazyredraw
  try
    normal! ma
    let current_buffer = bufnr('%')
    tabe
    " Left Window
    let w:focuswriting = 1
    setlocal nomodifiable readonly nobuflisted nonumber norelativenumber fillchars=eob:\  colorcolumn=0 winhighlight=Normal:NormalFloat
    vsplit
    vsplit
    " Right Window
    let w:focuswriting = 1
    setlocal nomodifiable readonly nobuflisted nonumber norelativenumber fillchars=eob:\  colorcolumn=0 winhighlight=Normal:NormalFloat
    wincmd h
    " Middle Window
    let w:focuswriting = 1
    vertical resize 88
    execute 'buffer ' .. current_buffer
    setlocal number norelativenumber wrap winfixwidth colorcolumn=0 nofoldenable conceallevel=3 concealcursor=nc
    wincmd =
    normal! `azz0
  finally
    set nolazyredraw
  endtry
endfunction

command! CleanUnicode call s:clean_unicode()
function! s:clean_unicode()
  set lazyredraw
  try
    let save = winsaveview()
    silent! %substitute/”/"/g
    silent! %substitute/“/"/g
    silent! %substitute/’/'/g
    silent! %substitute/‘/'/g
    silent! %substitute/—/-/g
    silent! %substitute/…/.../g
    silent! %substitute/​//g
    silent! %substitute/–/-/g
    silent! %substitute/‐/-/g
    silent! %substitute/ / /g
    silent! %substitute/　/ /g
    silent! %substitute/′/'/g
    silent! %substitute/″/"/g
    silent! %substitute/•/*/g
    silent! %substitute/·/*/g
    silent! %substitute/°/^/g
    silent! %substitute/™/(tm)/g
    silent! %substitute/©/(c)/g
    silent! %substitute/®/(r)/g
    silent! %substitute/×/x/g
    silent! %substitute/÷/\//g
    silent! %substitute/±/+\/-/g
    silent! %substitute/½/1\/2/g
    silent! %substitute/¼/1\/4/g
    silent! %substitute/¾/3\/4/g
    silent! %substitute/‽/?!/g
    silent! %substitute/¿/?/g
    silent! %substitute/¡/!/g
    call winrestview(save)
  finally
    set nolazyredraw
  endtry
endfunction

command! EditNvimConfig call s:edit_nvim_config()
function! s:edit_nvim_config()
  cd ~/config/dotfiles/.config/nvim
  edit  ~/config/dotfiles/.config/nvim/init.vim
  tabe ~/config/dotfiles/.config/nvim/lua/packages.lua
  wincmd h
  tabprevious
endfunction

command! ResizeTabs call s:resize_tabs()
function! s:resize_tabs()
  set lazyredraw
  try
    let current_tab = tabpagenr()
    tabdo wincmd =
    execute 'tabnext ' .. current_tab
  finally
    set nolazyredraw
  endtry
endfunction

command! TrimWhitespace call s:trim_whitespace()
function! s:trim_whitespace()
  set lazyredraw
  try
    let save = winsaveview()
    if &filetype ==? 'markdown' " Only trailing, 1 trailing, and 2+ trailing
      silent!              %substitute/^\s\+$//e
      silent! %global/\S\s$/substitute/\s$//g
      silent!              %substitute/\s\s\s\+$/  /e
    else
      silent! %substitute/\s\+$//e
    endif
    call winrestview(save)
  finally
    set nolazyredraw
  endtry
endfunction

command! -bang Con call s:conceal('<bang>')
function! s:conceal(bang)
  if a:bang ==# '!'
    setlocal conceallevel=0
    setlocal concealcursor=
  else
    setlocal conceallevel=3
    setlocal concealcursor=nc
  endif
endfunction

command! CtrlL call s:ctrl_l()
function! s:ctrl_l()
  silent! lua vim.lsp.buf.clear_references()
  diffupdate
  let @/ = '' " clears search highlighting
  redraw!
endfunction

" }}}
" Autocmds {{{
" Placed at top because some events (like ColorScheme) happen in init.vim

augroup init_custom
  autocmd!
  autocmd BufRead,BufNewFile *.github/workflows/*.{yml,yaml} set filetype=yaml.github
  autocmd BufRead,BufNewFile *.min.js set filetype=none
  autocmd BufRead,BufNewFile *.{1p,1pm,2pm,3pm,4pm,5pm} set filetype=nroff
  autocmd BufRead,BufNewFile poetry.lock set filetype=toml
  autocmd BufRead,BufNewFile renv.lock set filetype=json
  autocmd BufWritePre * TrimWhitespace
  autocmd InsertEnter * setlocal listchars=tab:│—→,lead:\ ,nbsp:+
  autocmd InsertLeave * setlocal listchars=tab:│—→,lead:\ ,nbsp:+,trail:-
  autocmd QuitPre * if exists("w:focuswriting") | only | endif
  autocmd TextYankPost * silent! lua vim.hl.on_yank({higroup="VisualNOS", timeout=250})
  autocmd VimLeavePre * lua vim.lsp.stop_client(vim.lsp.get_clients(), true)
  autocmd VimResized * ResizeTabs
augroup end

" }}}
" Settings {{{

lua vim.loader.enable(true) -- speed up lua load times (experimental)
lua require("settings")
lua require("packages")
colorscheme PaperColorSlim " https://vimcolorschemes.com
aunmenu PopUp.-2-
aunmenu PopUp.How-to\ disable\ mouse
digraph '' 699  " Hawaiian character ʻ
set completeopt=menuone,longest,fuzzy wildmode=longest:full
set cursorline cursorlineopt=number
set diffopt+=algorithm:histogram,inline:word,indent-heuristic
set expandtab shiftwidth=2 softtabstop=2
set exrc
set foldmethod=marker foldnestmax=1 foldcolumn=auto
set grepprg=rg\ --vimgrep
set guicursor=n-v-sm:block-Cursor,i-ci-c-ve:ver25-Cursor,r-cr-o:hor20-Cursor
set isfname+=@-@,:
set linebreak breakat=\ \	,])/- breakindent breakindentopt=list:-1
set list listchars=tab:│—→,lead:\ ,nbsp:+,trail:-
set mouse=a
set noshowcmd
set noswapfile
set notimeout
set number
set path+=/usr/include/x86_64-linux-gnu/
set shadafile=NONE
set shortmess+=c
set showtabline=2
set signcolumn=number
set spelllang=en_us
set splitright
set termguicolors
set updatetime=300
set winborder=rounded
let $PATH = $PWD .. '/node_modules/.bin:' .. $PATH
let g:clipboard = 'xsel'
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:markdown_recommended_style = 0
" https://github.com/pappasam/vim-filetype-formatter
let g:vim_filetype_formatter_ft_maps = {'yaml.github': 'yaml'}

" }}}
" Mappings {{{

let g:mapleader = ','
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>
cnoremap <C-u> <C-E><C-U>
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
nnoremap <Leader>eb <Cmd>edit ~/config/dotfiles/.bashrc<CR>
nnoremap <Leader>ek <Cmd>edit ~/config/dotfiles/.config/kitty/kitty.conf<CR>
nnoremap <Leader>ep <Cmd>edit ~/config/docs/samples/ai-prompts.md<CR>
nnoremap <Leader>ev <Cmd>EditNvimConfig<CR>
nnoremap <Leader>ez <Cmd>edit ~/config/dotfiles/.zshrc<CR>
xnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <expr> za line('.') == 1 ? 'za' : 'kjza'
" help lsp-defaults
nnoremap <Leader>d <Cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>
nnoremap <C-k> <Cmd>lua vim.lsp.buf.hover({max_width=79})<CR>
nnoremap K K
nnoremap grd <Cmd>lua vim.diagnostic.open_float()<CR>
nnoremap grD <Cmd>lua vim.diagnostic.setqflist()<CR>
nnoremap <C-h> <Cmd>lua vim.lsp.buf.document_highlight()<CR>
nnoremap <C-l> <Cmd>CtrlL<CR>
" help vim.snippet
snoremap <C-l> <Cmd>lua vim.snippet.stop()<CR><Esc>
nnoremap <Leader>s <Cmd>lua vim.snippet.stop()<CR>
" https://github.com/stevearc/aerial.nvim
nnoremap <Space>l zR<Cmd>AerialToggle<CR>
" https://github.com/pappasam/nvim-repl
nmap <silent> <Leader>r <Plug>(ReplSendLine)
xmap <silent> <Leader>r <Plug>(ReplSendVisual)
nmap <silent> <Leader>c <Plug>(ReplSendCell)
" https://github.com/coder/claudecode.nvim
nnoremap <leader>ac <cmd>ClaudeCode<cr>
nnoremap <leader>af <cmd>ClaudeCodeFocus<cr>
nnoremap <leader>ar <cmd>ClaudeCode --resume<cr>
nnoremap <leader>aC <cmd>ClaudeCode --continue<cr>
nnoremap <leader>am <cmd>ClaudeCodeSelectModel<cr>
nnoremap <leader>ab <cmd>ClaudeCodeAdd %<cr>
xnoremap <leader>as <cmd>ClaudeCodeSend<cr>
nnoremap <leader>aa <cmd>ClaudeCodeDiffAccept<cr>
nnoremap <leader>ad <cmd>ClaudeCodeDiffDeny<cr>
" https://github.com/machakann/vim-sandwich
nmap s <Nop>
xmap s <Nop>
" https://github.com/echasnovski/mini.nvim
nnoremap <C-p><C-b> <Cmd>Pick buffers<CR>
nnoremap <C-p><C-g> <Cmd>Pick grep_live<CR>
nnoremap <C-p><C-h> <Cmd>Pick help<CR>
nnoremap <C-p><C-p> <Cmd>Pick files tool=files_fd<CR>
nnoremap <Space>j <Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>
" https://github.com/pappasam/vim-filetype-formatter
nnoremap <Leader>f <Cmd>FiletypeFormat<CR>
xnoremap <Leader>f :FiletypeFormat<CR>
" https://github.com/lewis6991/gitsigns.nvim
nnoremap <Leader>gg <Cmd>Gitsigns toggle_word_diff<CR>
nnoremap <Leader>g= <Cmd>Gitsigns preview_hunk_inline<CR>
nnoremap <Leader>gu <Cmd>Gitsigns reset_hunk<CR>
" https://github.com/sindrets/diffview.nvim
nnoremap <Leader>gd <Cmd>DiffviewOpen<CR>

" }}}
