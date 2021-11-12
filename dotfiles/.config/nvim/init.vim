" General: packages {{{

" Note: vim-packager automatically executes UpdateRemotePlugins

function! s:packager_init(packager) abort
  call a:packager.add('git@github.com:kristijanhusak/vim-packager', {'type': 'opt'})

  " Autocompletion And IDE Features:
  call a:packager.add('git@github.com:neoclide/coc.nvim.git', {'branch': 'release'})
  call a:packager.add('git@github.com:pappasam/coc-jedi.git', {'do': 'yarn install --frozen-lockfile && yarn build'})

  " TreeSitter:
  call a:packager.add('git@github.com:nvim-treesitter/nvim-treesitter.git', {'do': ':TSUpdate'})
  call a:packager.add('git@github.com:nvim-treesitter/nvim-treesitter-textobjects.git')
  call a:packager.add('git@github.com:nvim-treesitter/playground.git')
  call a:packager.add('git@github.com:windwp/nvim-ts-autotag.git')
  call a:packager.add('git@github.com:JoosepAlviste/nvim-ts-context-commentstring.git')

  " LocationList:
  call a:packager.add('git@github.com:elbeardmorez/vim-loclist-follow.git')

  " Tim Pope: general, uncategorizable tim pope plugins
  " Notes:
  "   * abolish: convert to snake cases
  call a:packager.add('git@github.com:tpope/vim-abolish')
  call a:packager.add('git@github.com:tpope/vim-characterize.git')
  call a:packager.add('git@github.com:tpope/vim-commentary')
  call a:packager.add('git@github.com:tpope/vim-repeat')
  call a:packager.add('git@github.com:tpope/vim-scriptease')

  " General:
  call a:packager.add('git@github.com:Shougo/defx.nvim')
  call a:packager.add('git@github.com:bronson/vim-visual-star-search')
  call a:packager.add('git@github.com:fidian/hexmode')
  call a:packager.add('git@github.com:junegunn/vader.vim')
  call a:packager.add('git@github.com:kh3phr3n/tabline')
  call a:packager.add('git@github.com:kristijanhusak/defx-git')
  call a:packager.add('git@github.com:kristijanhusak/defx-icons')
  call a:packager.add('git@github.com:mbbill/undotree')
  call a:packager.add('git@github.com:qpkorr/vim-bufkill')
  call a:packager.add('git@github.com:ryvnf/readline.vim.git')
  call a:packager.add('git@github.com:simeji/winresizer')
  call a:packager.add('git@github.com:sjl/strftimedammit.vim')
  call a:packager.add('git@github.com:unblevable/quick-scope')
  call a:packager.add('git@github.com:wincent/ferret')
  call a:packager.add('git@github.com:yssl/QFEnter')
  call a:packager.add('git@github.com:folke/zen-mode.nvim.git')
  call a:packager.add('git@github.com:windwp/nvim-autopairs.git')
  call a:packager.add('git@github.com:ntpeters/vim-better-whitespace.git')

  " KeywordPrg:
  call a:packager.add('git@github.com:pappasam/vim-keywordprg-commands.git')
  call a:packager.add('git@github.com:romainl/vim-devdocs.git')

  " Fuzzy Finder:
  call a:packager.add('git@github.com:junegunn/fzf')
  call a:packager.add('git@github.com:junegunn/fzf.vim')

  " Git:
  call a:packager.add('git@github.com:tpope/vim-fugitive')
  " Gives command :Flog , which opens git history of repo. Alternative go :GV
  call a:packager.add('git@github.com:rbong/vim-flog.git')
  call a:packager.add('git@github.com:sodapopcan/vim-twiggy.git')
  call a:packager.add('git@github.com:rhysd/git-messenger.vim.git')
  call a:packager.add('git@github.com:nvim-lua/plenary.nvim.git')
  call a:packager.add('git@github.com:sindrets/diffview.nvim.git')
  call a:packager.add('git@github.com:kyazdani42/nvim-web-devicons.git')

  " Text Objects:
  call a:packager.add('git@github.com:machakann/vim-sandwich')
  call a:packager.add('git@github.com:kana/vim-textobj-user')
  " support additional delimiters
  call a:packager.add('git@github.com:EvanQuan/vim-textobj-delimiters.git')
  " al/il for the current line
  call a:packager.add('git@github.com:kana/vim-textobj-line')
  " as/is for a sentence of prose (overrides hard-coded native object & motion)
  call a:packager.add('git@github.com:reedes/vim-textobj-sentence')
  " az/iz for a block of folded lines; iz does not include fold marker lines
  call a:packager.add('git@github.com:somini/vim-textobj-fold')
  " ao/io for a block of indentation (i.e. spaces)
  call a:packager.add('git@github.com:glts/vim-textobj-indblock')
  " ay/iy for a syntax group
  call a:packager.add('git@github.com:kana/vim-textobj-syntax')
  " ae/ie for entire buffers
  call a:packager.add('git@github.com:kana/vim-textobj-entire.git')
  " ai/ii for similarly indented, aI/iI for same indentation
  call a:packager.add('git@github.com:kana/vim-textobj-indent.git')
  " au/iu for a URI, also includes URI handlers and is easy to extend
  call a:packager.add('git@github.com:jceb/vim-textobj-uri.git')

  " Writing:
  call a:packager.add('git@github.com:dkarter/bullets.vim')
  call a:packager.add('git@github.com:jlesquembre/rst-tables.nvim')
  call a:packager.add('git@github.com:junegunn/limelight.vim')
  call a:packager.add('git@github.com:moiatgit/vim-rst-sections')

  " Previewers:
  call a:packager.add('git@github.com:iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})
  call a:packager.add('git@github.com:tyru/open-browser.vim')
  call a:packager.add('git@github.com:weirongxu/plantuml-previewer.vim')

  " Code Formatters:
  call a:packager.add('git@github.com:pappasam/vim-filetype-formatter')

  " Repl Integration:
  " call a:packager.add('git@github.com:jpalardy/vim-slime.git')
  call a:packager.add('git@github.com:pappasam/nvim-repl.git')

  " Indentation Only:
  call a:packager.add('git@github.com:Vimjas/vim-python-pep8-indent')
  call a:packager.add('git@github.com:Yggdroot/indentLine')
  call a:packager.add('git@github.com:vim-scripts/groovyindent-unix')

  " Syntax Theme:
  call a:packager.add('git@github.com:pappasam/papercolor-theme-slim.git')

  " Jupyter Integration:
  call a:packager.add('git@github.com:goerz/jupytext.vim.git')

  " Syntax Highlighting:
  call a:packager.add('git@github.com:peitalin/vim-jsx-typescript.git')
  call a:packager.add('git@github.com:Glench/Vim-Jinja2-Syntax')
  call a:packager.add('git@github.com:NLKNguyen/c-syntax.vim')
  call a:packager.add('git@github.com:StanAngeloff/php.vim')
  call a:packager.add('git@github.com:autowitch/hive.vim')
  call a:packager.add('git@github.com:calviken/vim-gdscript3')
  call a:packager.add('git@github.com:chr4/nginx.vim.git')
  call a:packager.add('git@github.com:derekwyatt/vim-scala')
  call a:packager.add('git@github.com:evanleck/vim-svelte')
  call a:packager.add('git@github.com:farfanoide/vim-kivy')
  call a:packager.add('git@github.com:gisraptor/vim-lilypond-integrator.git')
  call a:packager.add('git@github.com:godlygeek/tabular')
  call a:packager.add('git@github.com:groenewege/vim-less')
  call a:packager.add('git@github.com:hashivim/vim-terraform')
  call a:packager.add('git@github.com:hashivim/vim-vagrant')
  call a:packager.add('git@github.com:jparise/vim-graphql')
  call a:packager.add('git@github.com:killphi/vim-ebnf')
  call a:packager.add('git@github.com:lervag/vimtex')
  call a:packager.add('git@github.com:marshallward/vim-restructuredtext')
  call a:packager.add('git@github.com:jxnblk/vim-mdx-js.git')
  call a:packager.add('git@github.com:martinda/Jenkinsfile-vim-syntax')
  call a:packager.add('git@github.com:mattn/vim-xxdcursor')
  call a:packager.add('git@github.com:mopp/rik_octave.vim')
  call a:packager.add('git@github.com:neoclide/jsonc.vim.git')
  call a:packager.add('git@github.com:neovimhaskell/haskell-vim')
  call a:packager.add('git@github.com:othree/html5.vim')
  call a:packager.add('git@github.com:pangloss/vim-javascript')
  call a:packager.add('git@github.com:aklt/plantuml-syntax.git')
  call a:packager.add('git@github.com:pearofducks/ansible-vim')
  call a:packager.add('git@github.com:raimon49/requirements.txt.vim')
  call a:packager.add('git@github.com:tpope/vim-markdown.git')
  call a:packager.add('git@github.com:ron-rs/ron.vim')
  call a:packager.add('git@github.com:rust-lang/rust.vim')
  call a:packager.add('git@github.com:tomlion/vim-solidity')
  call a:packager.add('git@github.com:vim-scripts/SAS-Syntax')
  call a:packager.add('git@github.com:vimoutliner/vimoutliner')
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'), {
      \ 'window_cmd': 'edit',
      \ })

command! PackInstall    PackagerInstall
command! PackUpdate     PackagerUpdate
command! PackClean      PackagerClean
command! PackStatus     PackagerStatus
command! PU             PackagerUpdate | PackagerClean

" }}}
" General: mappings {{{

let mapleader = ','

function! s:default_key_mappings()
  " Coc: settings for coc.nvim
  nmap     <silent>        <C-]> <Plug>(coc-definition)
  nmap     <silent>        <C-LeftMouse> <Plug>(coc-definition)
  nnoremap <silent>        <C-k> <Cmd>call CocActionAsync('doHover')<CR>
  inoremap <silent>        <C-s> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
  nnoremap <silent>        <C-w>f <Cmd>call coc#float#jump()<CR>
  nmap     <silent>        <leader>st <Plug>(coc-type-definition)
  nmap     <silent>        <leader>si <Plug>(coc-implementation)
  nmap     <silent>        <leader>su <Plug>(coc-references)
  nmap     <silent>        <leader>sr <Plug>(coc-rename)
  nmap     <silent>        <leader>sa v<Plug>(coc-codeaction-selected)
  vmap     <silent>        <leader>sa <Plug>(coc-codeaction-selected)
  nnoremap <silent>        <leader>sn <Cmd>CocNext<CR>
  nnoremap <silent>        <leader>sp <Cmd>CocPrev<CR>
  nnoremap <silent>        <leader>sl <Cmd>CocListResume<CR>
  nnoremap <silent>        <leader>sc <Cmd>CocList commands<cr>
  nnoremap <silent>        <leader>so <Cmd>CocList -A outline<cr>
  nnoremap <silent>        <leader>sw <Cmd>CocList -A -I symbols<cr>
  inoremap <silent> <expr> <c-space> coc#refresh()

  nnoremap <silent> <nowait> <expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  nnoremap <silent> <nowait> <expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"
  inoremap <silent> <nowait> <expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-e>"
  inoremap <silent> <nowait> <expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-y>"
  vnoremap <silent> <nowait> <expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  vnoremap <silent> <nowait> <expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"

  imap     <silent> <expr> <C-l> coc#expandable() ? "<Plug>(coc-snippets-expand)" : "\<C-y>"
  inoremap <silent> <expr> <CR> pumvisible() ? '<CR>' : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'
  nnoremap                 <leader>d <Cmd>call CocActionAsync('diagnosticToggle')<CR>
  nnoremap                 <leader>D <Cmd>call CocActionAsync('diagnosticPreview')<CR>
  nmap     <silent>        ]g <Plug>(coc-diagnostic-next)
  nmap     <silent>        [g <Plug>(coc-diagnostic-prev)

  " Escape: also clears highlighting
  nnoremap <silent> <esc> <Cmd>noh<return><esc>

  " J: unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " SearchBackward: remap comma to single quote
  nnoremap ' ,

  " Exit: Preview, Help, QuickFix, and Location List
  inoremap <silent> <C-c> <Esc>:pclose <BAR> cclose <BAR> lclose <CR>a
  nnoremap <silent> <C-c> :pclose <BAR> cclose <BAR> lclose <CR>

  " InsertModeHelpers: Insert one line above after enter
  inoremap <M-CR> <CR><C-o>O

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
  nnoremap <A-1> 1gt
  nnoremap <A-2> 2gt
  nnoremap <A-3> 3gt
  nnoremap <A-4> 4gt
  nnoremap <A-5> 5gt
  nnoremap <A-6> 6gt
  nnoremap <A-7> 7gt
  nnoremap <A-8> 8gt
  nnoremap <A-9> 9gt

  " Substitute: replace word under cursor
  nnoremap <leader><leader>s yiw:%s/\<<C-R>0\>//g<Left><Left>
  vnoremap <leader><leader>s y:%s/<C-R>0//g<Left><Left>

  " IndentComma: placing commas one line down; usable with repeat operator '.'
  nnoremap <silent> <Plug>NewLineComma f,wi<CR><Esc>
        \:call repeat#set("\<Plug>NewLineComma")<CR>
  nmap <leader><CR> <Plug>NewLineComma

  " Jinja2Toggle: the following mapping toggles jinja2 for any filetype
  nnoremap <silent> <leader><leader>j <Cmd>Jinja2Toggle<CR>

  " ToggleRelativeNumber: uses custom functions
  nnoremap <silent> <leader>R <Cmd>ToggleNumber<CR>
  nnoremap <silent> <leader>r <Cmd>ToggleRelativeNumber<CR>

  " TogglePluginWindows:
  nnoremap <silent> <space>j <Cmd>Defx
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:space:filename
        \ -direction=topleft
        \ -search=`expand('%:p')`
        \ -session-file=`g:custom_defx_state`
        \ -ignored-files=`g:defx_ignored_files`
        \ -split=vertical
        \ -toggle
        \ -floating-preview
        \ -vertical-preview
        \ -preview-height=50
        \ -preview-width=85
        \ -winwidth=31
        \ -root-marker=''
        \ <CR>
  nnoremap <silent> <space>J <Cmd>Defx `expand('%:p:h')`
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:space:filename
        \ -direction=topleft
        \ -search=`expand('%:p')`
        \ -ignored-files=`g:defx_ignored_files`
        \ -split=vertical
        \ -floating-preview
        \ -vertical-preview
        \ -preview-height=50
        \ -preview-width=85
        \ -winwidth=31
        \ -root-marker=''
        \ <CR>
  nnoremap <silent> <space>l <Cmd>CocOutline<CR>
  nnoremap <silent> <space>u <Cmd>UndotreeToggle<CR>

  " Override <C-w>H to delete defx buffers
  nnoremap <C-w>H <Cmd>windo if &filetype == 'defx' <bar> close <bar> endif<CR><C-w>H

  " Zenmode / Writing:
  nnoremap <leader><leader>g <Cmd>ZenMode<CR>
  nnoremap <leader><leader>l <Cmd>Limelight!!<CR>
  nmap     <leader><leader>v <Plug>Veil

  " IndentLines: toggle if indent lines is visible
  nnoremap <silent> <leader>i <Cmd>IndentLinesToggle<CR>

  " ResizeWindow: up and down; relies on custom functions
  nnoremap <silent> <leader><leader>h <Cmd>ResizeWindowHeight<CR>
  nnoremap <silent> <leader><leader>w <Cmd>ResizeWindowWidth<CR>

  " Repl: my very own repl plugin
  nnoremap <leader><leader>e <Cmd>ReplToggle<CR>
  nmap     <leader>e <Plug>ReplSendLine
  vmap     <leader>e <Plug>ReplSendVisual

  " Sandwich: below mappings address the issue raised here:
  " https://github.com/machakann/vim-sandwich/issues/62
  xmap s  <Nop>
  omap s  <Nop>
  xmap ib <Plug>(textobj-sandwich-auto-i)
  omap ib <Plug>(textobj-sandwich-auto-i)
  xmap ab <Plug>(textobj-sandwich-auto-a)
  omap ab <Plug>(textobj-sandwich-auto-a)
  xmap iq <Plug>(textobj-sandwich-query-i)
  omap iq <Plug>(textobj-sandwich-query-i)
  xmap aq <Plug>(textobj-sandwich-query-a)
  omap aq <Plug>(textobj-sandwich-query-a)

  " FZF: create shortcuts for finding stuff
  nnoremap <silent> <C-p><C-p> <Cmd>call <SID>fzf_avoid_defx('Files')<CR>
  nnoremap <silent> <C-p><C-b> <Cmd>call <SID>fzf_avoid_defx('Buffers')<CR>
  nnoremap          <C-n><C-n> yiw:Rg <C-r>"<CR>
  vnoremap          <C-n><C-n> y:Rg <C-r>"<CR>

  " FiletypeFormat: remap leader f to do filetype formatting
  nnoremap <silent> <leader>f <Cmd>FiletypeFormat<cr>
  vnoremap <silent> <leader>f :FiletypeFormat<cr>

  " Open Browser: override netrw
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  " GitMessenger:
  nmap <leader>sg <Plug>(git-messenger)

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Mouse Configuration: remaps mouse to work better in terminal

  " Out Jump List: <C-RightMouse> already mapped to something like <C-t>
  nnoremap <RightMouse> <C-o>

  " Clipboard Copy: Visual mode copy is pretty simple
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y

  " Mouse Copy: system copy mouse characteristics
  vnoremap <RightMouse> "+y

  " Mouse Paste: make it come from the system register
  nnoremap <MiddleMouse> "+<MiddleMouse>

  " Scrolling Dropdown: dropdown scrollable + click to select highlighted
  inoremap <expr> <S-ScrollWheelUp>   pumvisible() ? '<C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p>' : '<Esc><S-ScrollWheelUp>'
  inoremap <expr> <S-ScrollWheelDown> pumvisible() ? '<C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n>' : '<Esc><S-ScrollWheelDown>'
  inoremap <expr> <ScrollWheelUp>     pumvisible() ? '<C-p>' : '<Esc><ScrollWheelUp>'
  inoremap <expr> <ScrollWheelDown>   pumvisible() ? '<C-n>' : '<Esc><ScrollWheelDown>'
  inoremap <expr> <LeftMouse>         pumvisible() ? '<CR><Backspace>' : '<Esc><LeftMouse>'

  " Auto-execute all filetypes
  let &filetype=&filetype
endfunction

call s:default_key_mappings()

" helper to remap d, u, and q for readonly buffers
function! s:key_mappings_readonly()
  nnoremap <silent> <buffer> d <C-d>
  nnoremap <silent> <buffer> u <C-u>
  nnoremap <silent> <buffer> q <Cmd>q<CR>
endfunction

augroup custom_remap_click
  autocmd!
  autocmd FileType qf,markdown,rst nnoremap <buffer> <2-LeftMouse> <2-LeftMouse>
augroup end

" Mouse Open Close Folds: open folds with the mouse, and close the folds
" open operation taken from: https://stackoverflow.com/a/13924974
augroup custom_remap_folds
  autocmd!
  autocmd FileType vim,tmux,bash,zsh,sh nnoremap <expr> <2-LeftMouse> foldclosed(line('.')) == -1 ? '<2-LeftMouse>' : '<LeftMouse>zo'
  autocmd FileType vim,tmux,bash,zsh,sh nnoremap        <RightMouse> <LeftMouse><LeftRelease>zc
augroup end

augroup custom_remap_man_help
  autocmd!
  autocmd FileType man,help nnoremap <buffer> <silent> <C-]> <C-]>
  " make gO behave like CocOutline to man and help filetypes
  " works in conjunction with vim-loclist-follow
  autocmd FileType man,help nmap     <buffer> <silent> <space>l gO<C-w>L:vertical resize 37<cr>
  autocmd FileType man,help nnoremap <buffer>          <C-LeftMouse> <C-LeftMouse>
  autocmd FileType man,help nnoremap <buffer> <expr>   d &modifiable == 0 ? '<C-d>' : 'd'
  autocmd FileType man,help nnoremap <buffer> <expr>   u &modifiable == 0 ? '<C-u>' : 'u'
  autocmd FileType man,help nnoremap <buffer> <expr>   q &modifiable == 0 ? ':q<cr>' : 'q'
augroup end

augroup custom_remap_rst
  autocmd!
  autocmd FileType rst nnoremap <buffer>          <leader>w <Cmd>HovercraftSlide<CR>
  autocmd FileType rst nnoremap <buffer>          <leader>f <Cmd>TableRstFormat<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s0 <Cmd>call RstSetSection(0)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s1 <Cmd>call RstSetSection(1)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s2 <Cmd>call RstSetSection(2)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s3 <Cmd>call RstSetSection(3)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s4 <Cmd>call RstSetSection(4)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s5 <Cmd>call RstSetSection(5)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>s6 <Cmd>call RstSetSection(6)<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>sk <Cmd>call RstGoPrevSection()<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>sj <Cmd>call RstGoNextSection()<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>sa <Cmd>call RstIncrSectionLevel()<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>sx <Cmd>call RstDecrSectionLevel()<CR>
  autocmd FileType rst nnoremap <buffer> <silent> <leader>sl <Cmd>call RstSectionLabelize()<CR>
augroup end

augroup custom_remap_defx
  autocmd!
  autocmd FileType defx call s:defx_buffer_remappings()
  autocmd FileType defx nmap     <buffer> <silent>        gp <Plug>(defx-git-prev)
  autocmd FileType defx nmap     <buffer> <silent>        gn <Plug>(defx-git-next)
  autocmd FileType defx nmap     <buffer> <silent>        gs <Plug>(defx-git-stage)
  autocmd FileType defx nmap     <buffer> <silent>        gu <Plug>(defx-git-reset)
  autocmd FileType defx nmap     <buffer> <silent>        gd <Plug>(defx-git-discard)
  autocmd FileType defx nnoremap <buffer> <silent> <expr> <C-l> defx#do_action('resize', winwidth(0)+2)
  autocmd FileType defx nnoremap <buffer> <silent> <expr> <C-h> defx#do_action('resize', winwidth(0)-2)
augroup end

augroup custom_init_vim
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter init.vim nnoremap <buffer> <silent> gf <Cmd>call <SID>gf_vimrc_open_plugin()<CR>
  autocmd BufNewFile,BufRead,BufEnter init.vim nnoremap <buffer> <silent> gx <Cmd>call <SID>gx_vimrc_open_plugin()<CR>
augroup end

" }}}
" Package: coc.nvim {{{

let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
let g:coc_start_at_startup = 1
let g:coc_filetype_map = {
      \ 'python.jinja2': 'python',
      \ 'sql.jinja2': 'sql',
      \ 'yaml.ansible': 'yaml',
      \ 'yaml.docker-compose': 'yaml',
      \ 'jinja.html': 'html',
      \ }

" Coc Global Extensions: automatically installed on Vim open
let g:coc_global_extensions = [
      \ '@yaegassy/coc-nginx',
      \ 'coc-angular',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-dictionary',
      \ 'coc-docker',
      \ 'coc-emoji',
      \ 'coc-go',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-markdownlint',
      \ 'coc-rls',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-svelte',
      \ 'coc-svg',
      \ 'coc-syntax',
      \ 'coc-texlab',
      \ 'coc-toml',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-word',
      \ 'coc-yaml',
      \ 'coc-yank',
      \ ]

function! s:autocmd_custom_coc()
  if !exists("g:did_coc_loaded")
    return
  endif
  augroup custom_coc
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " Coc nvim might override my mappings. I call them again just in case.
    autocmd User CocNvimInit call s:default_key_mappings()
  augroup end
endfunction

augroup custom_coc
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_coc()
  autocmd User CocNvimInit * call s:default_key_mappings()
augroup end

augroup custom_coc_additional_keyword_characters
  autocmd!
  autocmd FileType nginx let b:coc_additional_keywords = ['$']
augroup end

" coc.nvim custom async update function
function! s:CocUpdateCallback(err, ...) abort
  if a:err
    echo a:err
  else
    quitall
  endif
endfunction

command! CocUpdateAsyncWaitThenQuit :call CocActionAsync('updateExtensions', v:false, function('<sid>CocUpdateCallback'))

" }}}
" Package: treesitter {{{

function s:init_treesitter()
lua << EOF
local ok, _ = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('nvim-treesitter does not exist, skipping...')
  return
end
-- nvim-treesitter/queries/python/injections.scm, with docstring
-- injections removed
local py_injections = [[
((call
  function: (attribute object: (identifier) @_re)
  arguments: (argument_list (string) @regex))
 (#eq? @_re "re")
 (#match? @regex "^r.*"))

(comment) @comment
]]
vim.treesitter.set_query('python', 'injections', py_injections)
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
      },
    },
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    'bash',
    'bibtex',
    'c',
    'cpp',
    'css',
    'dockerfile',
    'gdscript',
    'go',
    'graphql',
    'hcl',
    'html',
    'java',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'julia',
    'latex',
    'ledger',
    'lua',
    'ocaml',
    'php',
    'python',
    'query',
    'regex',
    'rst',
    'ruby',
    'rust',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vim',
}})
EOF
endfunction

augroup custom_treesitter
  autocmd!
  autocmd VimEnter * call s:init_treesitter()
augroup end

" }}}
" General: options {{{

" Enable filetype detection, plugin loading, and indentation loading
filetype plugin indent on

" Code Completion:
set completeopt=menuone,longest
set wildmode=longest:full
set wildmenu

" Messages:
" c = don't give |ins-completion-menu| messages; they're noisy
" I = ignore startup message
set shortmess+=c
set shortmess+=I

" Hidden Buffer: enable instead of having to write each buffer
set hidden

" Sign Column: always show it
set signcolumn=number

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set noswapfile

" Command Line Height: higher for display for messages
set cmdheight=2

" Line Wrapping: do not wrap lines by default
set nowrap

" Indentation:
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=8

" Filename: for gf (@-@='@', see: https://stackoverflow.com/a/45244758)
set isfname+=@-@
set isfname+=:

" Highlight Search: do that
" note: hlsearcha nd nohlsearch are defined in autocmd outside function
set incsearch
set inccommand=nosplit

" Spell Checking:
set dictionary=$HOME/.american-english-with-propcase.txt
set spelllang=en_us

" Single Space After Punctuation: useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

set autoread

set grepprg=rg\ --vimgrep

" Paste: this is actually typed <C-/>, but term nvim thinks this is <C-_>
set pastetoggle=<C-_>

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

" Set Background: defaults do dark
set background=dark

" Colorcolumn:
set colorcolumn=80

" Status Line: specifics for custom status line
set laststatus=2
set ttimeoutlen=50
set noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" Updatetime: time Vim waits to do something after I stop moving
set updatetime=300

" Linux Dev Path: system libraries
set path+=/usr/include/x86_64-linux-gnu/

" Vim History: for command line; can't imagine that more than 100 is needed
set history=100

" Redraw Window: whenever a window regains focus
augroup custom_redraw_on_refocus
  autocmd!
  autocmd FocusGained * redraw!
augroup end

augroup custom_incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup end

augroup custom_nginx
  autocmd!
  autocmd FileType nginx set iskeyword+=$
  autocmd FileType zsh,sh set iskeyword+=-
augroup end

" Make Python support work better with asdf
let g:python3_host_prog = "$HOME/.asdf/shims/python"
let g:loaded_python_provider = 0

" }}}
" General: alacritty callback for dynamic terminal color change {{{

" set environment variables based on light or dark
function s:set_env_from_background()
  let $BAT_THEME = &background == 'light' ?
        \ 'Monokai Extended Light' : 'Monokai Extended'
endfunction

function! s:alacritty_set_background()
  let g:alacritty_background = system('alacritty-which-colorscheme')
  if !v:shell_error
    let &background = g:alacritty_background
  else
    echom 'Error calling "alacritty-which-colorscheme"'
  endif
  call s:set_env_from_background()
endfunction

call s:alacritty_set_background()
call jobstart(
      \ 'ls ' . $HOME . '/.alacritty.yml | entr -ps "echo alacritty_change"',
      \ {'on_stdout': { j, d, e -> s:alacritty_set_background() }}
      \ )

" }}}
" General: syntax and colorscheme {{{

augroup custom_syntax_typescript
  autocmd!
  " typescriptParens are stupidly linked to 'Normal' in Neovim.
  " This causes problems with hover windows in coc and is solved here
  autocmd ColorScheme * highlight link typescriptParens cleared
augroup end

augroup custom_syntax_whitespace
  autocmd!
  autocmd ColorScheme * highlight link ExtraWhitespace DiffText
augroup end

augroup custom_syntax_coc
  autocmd!
  autocmd ColorScheme * highlight link HighlightedyankRegion Search
  autocmd ColorScheme * highlight link CocHighlightText Underlined
augroup end

try
  colorscheme PaperColorSlim
catch
  echo 'An error occurred while configuring Papercolor'
endtry

" }}}
" General: filetype {{{

augroup custom_filetype_recognition
  autocmd!
  autocmd BufEnter *.asm set filetype=nasm
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf set filetype=dosini
  autocmd BufEnter *.config,.cookiecutterrc set filetype=yaml
  autocmd BufEnter *.handlebars set filetype=html
  autocmd BufEnter *.hql,*.q set filetype=hive
  autocmd BufEnter *.js,*.gs set filetype=javascript
  autocmd BufEnter *.min.js set filetype=none
  autocmd BufEnter *.m,*.oct set filetype=octave
  autocmd BufEnter *.py.j2 set filetype=python.jinja2
  autocmd BufEnter *.sql.j2 set filetype=sql.jinja2
  autocmd BufEnter *.toml set filetype=toml
  autocmd BufEnter *.tsv set filetype=tsv
  autocmd BufEnter .envrc set filetype=sh
  autocmd BufEnter .gitignore,.dockerignore set filetype=conf
  autocmd BufEnter .jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term set filetype=json
  autocmd BufEnter Dockerfile.* set filetype=dockerfile
  autocmd BufEnter Makefile.* set filetype=make
  autocmd BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
  autocmd BufEnter .zshrc set filetype=sh
augroup end

" }}}
" General: indentation {{{

augroup custom_indentation
  autocmd!
  " 4 spaces per tab, not 2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  " Use hard tabs, not spaces
  autocmd Filetype make,tsv,votl,go,gomod setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
  autocmd Filetype dot setlocal autoindent cindent
  autocmd Filetype ron setlocal cindent
        \ cinkeys=0{,0},0(,0),0[,0],:,0#,!^F,o,O,e
        \ cinoptions+='(s,m2'
        \ cinoptions+='(s,U1'
        \ cinoptions+='j1'
        \ cinoptions+='J1'
augroup end

" }}}
" General: statusline & tabline {{{

" Tab Line
set tabline=%t

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
set statusline+=\ %y\  " file type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding

" Status Line
augroup custom_statusline
  autocmd!
  autocmd FileType defx setlocal statusline=\ defx\ %#CursorLine#
augroup end

" }}}
" General: environment variables {{{

" Path: add node_modules for language servers / linters / other stuff
let $PATH = $PWD . '/node_modules/.bin:' . $PATH

" }}}
" General: helptags {{{

helptags ~/.config/nvim/doc

" }}}
" General: init.vim helpers {{{

function! s:gf_vimrc_open_plugin()
  let ssh_url = expand('<cfile>')
  let ssh_components = split(ssh_url, '/')
  if len(ssh_components) != 2
    " do regular 'gf'
    normal! gf
    return
  endif
  let directory = ssh_components[1]
  let parent_directory = directory == 'vim-packager' ? 'opt/' : 'start/'
  let path = '~/.config/nvim/pack/packager/' . parent_directory . directory
  execute 'tabe ' . path
  execute 'lcd ' . path
endfunction

function! s:gx_vimrc_open_plugin()
  let ssh_url = expand('<cfile>')
  let ssh_components = split(ssh_url, ':')
  if len(ssh_components) != 2
    " do regular 'gx'
    normal! gx
    return
  endif
  let path = ssh_components[1]
  execute 'OpenBrowser ' . 'https://github.com/' . path
endfunction

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

" Using Ack and Acks brings up quickfix automatically
cnoreabbrev <expr> Ack <SID>abbr_help('Ack', 'Ack<C-f>i')
cnoreabbrev <expr> Acks <SID>abbr_help('Acks', 'Acks<C-f>i')

" Open init.vim
cnoreabbrev <expr> v <SID>abbr_help('v', 'edit ~/dotfiles/dotfiles/.config/nvim/init.vim')

" Open zshrc
cnoreabbrev <expr> z <SID>abbr_help('z', 'edit ~/dotfiles/dotfiles/.zshrc')

" Open settings for language server files
cnoreabbrev <expr> coc <SID>abbr_help('coc', 'edit ~/dotfiles/dotfiles/.config/nvim/coc-settings.json')
cnoreabbrev <expr> snip <SID>abbr_help('snip', 'CocCommand snippets.editSnippets')

" 'c' is abbreviation for 'close'. I use it way more often than 'change'
cnoreabbrev <expr> c <SID>abbr_help('c', 'close')

" }}}
" General: comment & text format options {{{

" Notes:
" commentstring: read by vim-commentary; must be one template
" comments: csv of comments.
" formatoptions: influences how Vim formats text
"   ':help fo-table' will get the desired result
augroup custom_comment_config
  autocmd!
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
augroup end

" }}}
" General: colorColumn different widths for different filetypes {{{

augroup custom_colorcolumn
  autocmd!
  autocmd FileType gitcommit setlocal colorcolumn=73 textwidth=72
  autocmd Filetype html,text,markdown,rst,fzf setlocal colorcolumn=0
augroup end

" }}}
" General: writing {{{

function! s:abolish_correct()
  " Started from:
  " https://github.com/tpope/tpope/blob/94b1f7c33ee4049866f0726f96d9a0fb5fdf868f/.vim/after/plugin/abolish_tpope.vim
  if !exists('g:loaded_abolish')
    echom 'Abolish does not exist, skipping...'
    return
  endif
  Abolish Lidsa                       Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  Abolish Tqbf                        The quick, brown fox jumps over the lazy dog
  Abolish adn                         and
  Abolish afterword{,s}               afterward{}
  Abolish anomol{y,ies}               anomal{}
  Abolish austrail{a,an,ia,ian}       austral{ia,ian}
  Abolish cal{a,e}nder{,s}            cal{e}ndar{}
  Abolish delimeter{,s}               delimiter{}
  Abolish despara{te,tely,tion}       despera{}
  Abolish destionation{,s}            destination{}
  Abolish d{e,i}screp{e,a}nc{y,ies}   d{i}screp{a}nc{}
  Abolish euphamis{m,ms,tic,tically}  euphemis{}
  Abolish hense                       hence
  Abolish hte                         the
  Abolish improvment{,s}              improvement{}
  Abolish inherant{,ly}               inherent{}
  Abolish lastest                     latest
  Abolish nto                         not
  Abolish nto                         not
  Abolish ot                          to
  Abolish persistan{ce,t,tly}         persisten{}
  Abolish rec{co,com,o}mend{,s,ed,ing,ation} rec{om}mend{}
  Abolish referesh{,es}               refresh{}
  Abolish reproducable                reproducible
  Abolish resouce{,s}                 resource{}
  Abolish restraunt{,s}               restaurant{}
  Abolish scflead                     supercalifragilisticexpialidocious
  Abolish segument{,s,ed,ation}       segment{}
  Abolish seperat{e,es,ed,ing,ely,ion,ions,or} separat{}
  Abolish si                          is
  Abolish teh                         the
  Abolish {,in}consistan{cy,cies,t,tly} {}consisten{}
  Abolish {,ir}releven{ce,cy,t,tly}   {}relevan{}
  Abolish {,non}existan{ce,t}         {}existen{}
  Abolish {,re}impliment{,s,ing,ed,ation} {}implement{}
  Abolish {,un}nec{ce,ces,e}sar{y,ily} {}nec{es}sar{}
  Abolish {,un}orgin{,al}             {}origin{}
  Abolish {c,m}arraige{,s}            {}arriage{}
  Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or} {despe,sepa}rat{}
  Abolish {les,compar,compari}sion{,s} {les,compari,compari}son{}
endfunction

augroup custom_writing
  autocmd!
  autocmd VimEnter * call s:abolish_correct()
  autocmd FileType markdown,rst,text,gitcommit setlocal wrap linebreak nolist | call textobj#sentence#init()
  autocmd FileType requirements setlocal nospell
  autocmd BufNewFile,BufRead *.html,*.tex setlocal wrap linebreak nolist
augroup end

" }}}
" General: digraphs {{{

digraph jj 699  " Hawaiian character ʻ

" }}}
" General: folding {{{

augroup custom_fold_settings
  autocmd!
  autocmd FileType vim,tmux,bash,zsh,sh setlocal foldenable foldmethod=marker foldnestmax=1
  autocmd FileType markdown,rst setlocal nofoldenable
  autocmd FileType yaml setlocal nofoldenable foldmethod=indent foldnestmax=1
augroup end

" }}}
" General: cursorline {{{

augroup custom_cursorline
  autocmd!
  autocmd FileType defx,qf setlocal cursorline
augroup end

" }}}
" General: trailing whitespace {{{

function! s:trim_whitespace()
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

command! TrimWhitespace call s:trim_whitespace()

augroup custom_fix_whitespace_save
  autocmd!
  autocmd BufWritePre * TrimWhitespace
augroup end

" }}}
" General: resize window {{{

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
" General: avoid saving 'lcd' {{{

augroup custom_no_save_lcd
  autocmd!
  autocmd User BufStaySavePre
        \ if haslocaldir() |
        \ let w:lcd = getcwd() |
        \ execute 'cd '.fnameescape(getcwd(-1, -1)) |
        \ endif
  autocmd User BufStaySavePost
        \ if exists('w:lcd') |
        \ execute 'lcd' fnameescape(w:lcd) |
        \ unlet w:lcd |
        \ endif
augroup end

" }}}
" General: delete hidden buffers {{{

" From: https://stackoverflow.com/a/7321131

function! s:delete_inactive_buffers()
  "From tabpagebuflist() help, get a list of all buffers in all tabs
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  "Below originally inspired by Hara Krishna Dara and Keith Roberts
  "http://tech.groups.yahoo.com/group/vim/message/56425
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      " bufno exists AND isn't modified
      " AND isn't in the list of buffers open in windows and tabs
      " Force buffer deletion (even for terminals)
      silent exec 'bwipeout!' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

command! DeleteInactiveBuffers call s:delete_inactive_buffers()

" }}}
" General: clean unicode {{{

" Replace unicode symbols with cleaned, ascii versions
function! s:clean_unicode()
  silent! %s/”/"/g
  silent! %s/“/"/g
  silent! %s/’/'/g
  silent! %s/‘/'/g
  silent! %s/—/-/g
  silent! %s/…/.../g
endfunction()
command! CleanUnicode call s:clean_unicode()

" }}}
" General: neovim terminal {{{

function! s:open_term_interactive(view_type)
  execute a:view_type
  terminal
  setlocal nonumber nornu
  startinsert
endfunction

command! Term call s:open_term_interactive('vsplit')
command! VTerm call s:open_term_interactive('vsplit')
command! STerm call s:open_term_interactive('split')
command! Tterm call s:open_term_interactive('tabnew')

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
" General: command abbreviations {{{

" Fix highlighting
command! FixHighlight syntax sync fromstart

" Save and quit all windows. Really easy to type and X is not mapped in Neovim
command! X xa

" }}}
" General: view available colors {{{

" From https://vim.fandom.com/wiki/View_all_colors_available_to_gvim
" There are some sort options at the end you can uncomment to your preference
"
" Create a new scratch buffer:
" - Read file $VIMRUNTIME/rgb.txt
" - Delete lines where color name is not a single word (duplicates).
" - Delete 'grey' lines (duplicate 'gray'; there are a few more 'gray').
" Add syntax so each color name is highlighted in its color.
function! s:vim_colors()
  vnew
  set modifiable
  setlocal filetype=vimcolors buftype=nofile bufhidden=delete noswapfile
  0read $VIMRUNTIME/rgb.txt
  let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
  silent execute 'v/' . find_color . '/d'
  silent g/grey/d
  let namedcolors = []
  1
  while search(find_color, 'W') > 0
    let word = expand('<cword>')
    call add(namedcolors, word)
  endwhile
  for w in namedcolors
    execute 'highlight col_' . w . ' guifg=black guibg=' . w
    execute 'highlight col_' . w . '_fg guifg=' . w . ' guibg=NONE'
    execute '%s/\<' . w . '\>/' . printf("%-36s%s", w, w . '_fg') . '/g'
    execute 'syntax keyword col_' . w . ' ' . w
    execute 'syntax keyword col_' . w . '_fg ' . w . '_fg'
  endfor
  " Add hex value column (and format columns nicely)
  %s/^\s*\(\d\+\)\s\+\(\d\+\)\s\+\(\d\+\)\s\+/\=printf(" %3d %3d %3d   #%02x%02x%02x   ", submatch(1), submatch(2), submatch(3), submatch(1), submatch(2), submatch(3))/
  1
  nohlsearch
  call s:key_mappings_readonly()
  file VimColors
  set nomodifiable
endfunction

command! VimColors silent call s:vim_colors()

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
" General: skeleton templates {{{

" https://vi.stackexchange.com/a/3833
function! s:randnum(max) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

" Create temporary file from skeleton
function! s:skeleton(file_skeleton)
  let parts = split(a:file_skeleton, '\.')
  let fn = join([parts[0] . '-' . s:randnum(10000)] + parts[1:], '.')
  execute 'edit ' . fn
  execute 'read ' $HOME . '/.config/nvim/skeletons/' . a:file_skeleton
  0delete_
  /{{Cursor}}
  normal! n
  normal! da{
  startinsert!
endfunction

command! Clubhouse silent call s:skeleton('clubhouse.md')
command! Standup silent call s:skeleton('standup.md')
command! Mentor silent call s:skeleton('mentor.md')

" }}}
" Package: nvim-ts-context-commentstring {{{

function s:init_ts_context_commentstring()
  if !exists('g:loaded_commentary')
    echom 'ts context commentstring does not exist, skipping...'
    return
  endif
lua << EOF
local ok, _ = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('nvim-treesitter does not exist, skipping...')
  return
end
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true
  }
}
EOF
endfunction

augroup custom_ts_context_commentstring
  autocmd!
  autocmd VimEnter * call s:init_ts_context_commentstring()
augroup end

" }}}
" Package: git plugins: gv.vim, fugitive, git-messenger {{{

" NOTES:
" :GV to open commit browser
"     You can pass git log options to the command, e.g. :GV -S foobar.
" :GV! will only list commits that affected the current file
" :GV? fills the location list with the revisions of the current file

" :GV or :GV? can be used in visual mode to track the changes in the selected lines.
" Mappings

" o or <cr> on a commit to display the content of it
" o or <cr> on commits to display the diff in the range
" O opens a new tab instead
" gb for :Gbrowse
" ]] and [[ to move between commits
" . to start command-line with :Git [CURSOR] SHA à la fugitive
" q or gq to close

let g:git_messenger_always_into_popup = v:false
let g:git_messenger_no_default_mappings = v:true

" Set the diff expression to EnhancedDiff
set diffopt+=internal,algorithm:patience

" }}}
" Package: diffview {{{

function s:init_diffview()
  if !exists('g:diffview_nvim_loaded')
    echom 'diffview does not exist, skipping...'
    return
  endif
lua << EOF
local cb = require'diffview.config'.diffview_callback
require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  use_icons = true,         -- Requires nvim-web-devicons
  enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    position = "left",      -- One of 'left', 'right', 'top', 'bottom'
    width = 35,             -- Only applies when position is 'left' or 'right'
    height = 10,            -- Only applies when position is 'top' or 'bottom'
  },
  file_history_panel = {
    position = "bottom",
    width = 35,
    height = 16,
    log_options = {
      max_count = 256,      -- Limit the number of commits
      follow = false,       -- Follow renames (only for single file)
      all = false,          -- Include all refs under 'refs/' including HEAD
      merges = false,       -- List only merge commits
      no_merges = false,    -- List no merge commits
      reverse = false,      -- List commits in reverse order
    },
  },
  key_bindings = {
    disable_defaults = true,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]      = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]    = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["gf"]         = cb("goto_file"),          -- Open the file in a new split in previous tabpage
      ["<C-w><C-f>"] = cb("goto_file_split"),    -- Open the file in a new split
      ["<C-w>gf"]    = cb("goto_file_tab"),      -- Open the file in a new tabpage
      ["<leader>e"]  = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"]  = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),          -- Stage all entries.
      ["U"]             = cb("unstage_all"),        -- Unstage all entries.
      ["X"]             = cb("restore_entry"),      -- Restore entry to the state on the left side.
      ["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    file_history_panel = {
      ["g!"]            = cb("options"),            -- Open the option panel
      ["d"]         = cb("open_in_diffview"),   -- Open the entry under the cursor in a diffview
      ["zR"]            = cb("open_all_folds"),
      ["zM"]            = cb("close_all_folds"),
      ["j"]             = cb("next_entry"),
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    option_panel = {
      ["<tab>"] = cb("select"),
      ["q"]     = cb("close"),
    },
  },
}
EOF
endfunction

augroup custom_diffview
  autocmd!
  autocmd VimEnter * call s:init_diffview()
  autocmd FileType DiffviewFiles,DiffviewFileHistory nnoremap <buffer> <silent> q <Cmd>tabclose<cr>
  autocmd FileType DiffviewFiles,DiffviewFileHistory cnoreabbrev <buffer> <silent> <expr> q <SID>abbr_help('q', 'tabclose')
  autocmd FileType DiffviewFiles,DiffviewFileHistory cnoreabbrev <buffer> <silent> <expr> qu <SID>abbr_help('qu', 'tabclose')
  autocmd FileType DiffviewFiles,DiffviewFileHistory cnoreabbrev <buffer> <silent> <expr> qui <SID>abbr_help('qui', 'tabclose')
  autocmd FileType DiffviewFiles,DiffviewFileHistory cnoreabbrev <buffer> <silent> <expr> quit <SID>abbr_help('quit', 'tabclose')
  autocmd FileType DiffviewFiles,DiffviewFileHistory nnoremap <buffer> <silent> <space>j <Cmd>DiffviewToggleFiles<cr>
augroup end

" }}}
" Package: nvim-web-icons {{{

function s:init_nvim_web_icons()
  if !exists('g:loaded_devicons')
    echom 'devicons does not exist, skipping...'
    return
  endif
lua << EOF
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    name = "Zsh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
EOF
endfunction

augroup custom_nvim_web_icons
  autocmd!
  autocmd VimEnter * call s:init_nvim_web_icons()
augroup end

" }}}
" Package: jinja2 {{{

function! s:jinja2_toggle()
  let jinja2 = '.jinja2'
  let jinja2_pattern = '\' . jinja2
  if matchstr(&ft, jinja2_pattern) == ""
    let new_filetype = &ft . jinja2
  else
    let new_filetype = substitute(&ft, jinja2_pattern, "", "")
  endif
  execute "set filetype=" . new_filetype
endfunction

command! Jinja2Toggle call s:jinja2_toggle()

" }}}
" Package: man pager {{{

let g:man_hardwrap = v:true

augroup custom_man_page
  autocmd!
  autocmd FileType man setlocal number
augroup end

" }}}
" Package: gv.vim (GV) {{{

" Commands:
"   :GV  to open commit browser. You can pass git log options to the command,
"        e.g. :GV -S foobar.
"   :GV! will only list commits that affected the current file
"   :GV? fills the location list with the revisions of the current file

" :GV or :GV? can be used in visual mode to track the changes in the selected
" lines.

" Mappings:
"     o or <cr> on a commit to display the content of it
"     o or <cr> on commits to display the diff in the range
"     O opens a new tab instead
"     gb for :Gbrowse
"     ]] and [[ to move between commits
"     . to start command-line with :Git [CURSOR] SHA à la fugitive
"     q/gq to close

" }}}
" Package: restructured text {{{

" Vim Rst Sections: documentation
" -----------------------------------------------------------------------
" Shortcuts:
" press your *leader* key followed by *s* and then:
"   * a number from 0 to 6 to set the section level (RstSetSection(level))
"   * k or j to jump to the previuos or next section
"   * a or x to increase or decrease the section level
"   * l to labelize

" Conventional Markup Hierarchy:
"   1. # with overline, for parts
"   2. * with overline, for chapters
"   3. =, for sections
"   4. -, for subsections
"   5. ^, for subsubsections
"   6. ", for paragraphs

" Source: https://stackoverflow.com/a/30772902
function! s:line_match_count(pat,...)
  " searches for pattern matches in the active buffer, with optional start and
  " end line number specifications

  " useful command-line for testing against last-used pattern within last-used
  " visual selection: echo s:line_match_count(@/,getpos("'<")[1],getpos("'>")[1])

  if (a:0 > 2) | echoerr 'too many arguments for function: s:line_match_count()'
        \ | return| endif
  let start = a:0 >= 1 ? a:000[0] : 1
  let end = a:0 >= 2 ? a:000[1] : line('$')
  "" validate args
  if (type(start) != type(0))
        \ | echoerr 'invalid type of argument: start' | return | endif
  if (type(end) != type(0))
        \ | echoerr 'invalid type of argument: end' | return | endif
  if (end < start)| echoerr 'invalid arguments: end < start'| return | endif
  "" save current cursor position
  let wsv = winsaveview()
  "" set cursor position to start (defaults to start-of-buffer)
  call setpos('.',[0,start,1,0])
  "" accumulate line count in local var
  let lineCount = 0
  "" keep searching until we hit end-of-buffer
  let ret = search(a:pat,'cW')
  while (ret != 0)
    " break if the latest match was past end; must do this prior to
    " incrementing lineCount for it, because if the match start is past end,
    " it's not a valid match for the caller
    if (ret > end)
      break
    endif
    let lineCount += 1
    " always move the cursor to the start of the line following the latest
    " match; also, break if we're already at end; otherwise next search would
    " be unnecessary, and could get stuck in an infinite loop if end ==
    " line('$')
    if (ret == end)
      break
    endif
    call setpos('.',[0,ret+1,1,0])
    let ret = search(a:pat,'cW')
  endwhile
  "" restore original cursor position
  call winrestview(wsv)
  "" return result
  return lineCount
endfunction

command! HovercraftSlide echo 'Slide '
      \ . s:line_match_count('^----$', 1, line('.'))

let g:no_rst_sections_maps = 0

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
    !gio open %:p
  endif
endfunction

command! Preview call s:preview()

" }}}
" Package: defx {{{

let g:custom_defx_state = tempname()

let g:defx_ignored_files = join([
      \ '*.aux',
      \ '*.egg-info/',
      \ '*.o',
      \ '*.out',
      \ '*.pdf',
      \ '*.pyc',
      \ '*.toc',
      \ '.*',
      \ '__pycache__/',
      \ 'build/',
      \ 'dist/',
      \ 'docs/_build/',
      \ 'fonts/',
      \ 'node_modules/',
      \ 'pip-wheel-metadata/',
      \ 'plantuml-images/',
      \ 'site/',
      \ 'target/',
      \ 'venv.bak/',
      \ 'venv/',
      \ ], ',')

let g:custom_defx_mappings = [
      \ ['!             ', "defx#do_action('execute_command')"],
      \ ['*             ', "defx#do_action('toggle_select_all')"],
      \ [';             ', "defx#do_action('repeat')"],
      \ ['<2-LeftMouse> ', "defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')"],
      \ ['<C-g>         ', "defx#do_action('print')"],
      \ ['<C-r>         ', "defx#do_action('redraw')"],
      \ ['<C-t>         ', "defx#do_action('open', 'tabe')"],
      \ ['<C-v>         ', "defx#do_action('open', 'vsplit')"],
      \ ['<C-x>         ', "defx#do_action('drop', 'split')"],
      \ ['<CR>          ', "defx#do_action('drop')"],
      \ ['<RightMouse>  ', "defx#do_action('cd', ['..'])"],
      \ ['O             ', "defx#do_action('open_tree', 'recursive:3')"],
      \ ['p             ', "defx#do_action('preview')"],
      \ ['a             ', "defx#do_action('toggle_select')"],
      \ ['cc            ', "defx#do_action('copy')"],
      \ ['cd            ', "defx#do_action('change_vim_cwd')"],
      \ ['i             ', "defx#do_action('toggle_ignored_files')"],
      \ ['ma            ', "defx#do_action('new_file')"],
      \ ['md            ', "defx#do_action('remove')"],
      \ ['mm            ', "defx#do_action('rename')"],
      \ ['o             ', "defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')"],
      \ ['P             ', "defx#do_action('paste')"],
      \ ['q             ', "defx#do_action('quit')"],
      \ ['ss            ', "defx#do_action('multi', [['toggle_sort', 'TIME'], 'redraw'])"],
      \ ['t             ', "defx#do_action('open_tree', 'toggle')"],
      \ ['u             ', "defx#do_action('cd', ['..'])"],
      \ ['x             ', "defx#do_action('execute_system')"],
      \ ['yy            ', "defx#do_action('yank_path')"],
      \ ['~             ', "defx#do_action('cd')"],
      \ ]

function! s:autocmd_custom_defx()
  if !exists('g:loaded_defx')
    return
  endif
  call defx#custom#column('filename', {
        \ 'min_width': 10,
        \ 'max_width_percent': 90,
        \ })
endfunction

function! s:open_defx_if_directory()
  if !exists('g:loaded_defx')
    echom 'Defx not installed, skipping...'
    return
  endif
  if isdirectory(expand(expand('%:p')))
    Defx `expand('%:p')`
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:space:filename
        \ -ignored-files=`g:defx_ignored_files`
        \ -floating-preview
        \ -vertical-preview
        \ -preview-height=50
        \ -preview-width=85
  endif
endfunction

function! s:defx_redraw()
  if !exists('g:loaded_defx')
    return
  endif
  call defx#redraw()
endfunction

function! s:defx_buffer_remappings() abort
  " Define mappings
  for [key, value] in g:custom_defx_mappings
    execute 'nnoremap <silent><buffer><expr> ' . key . ' ' . value
  endfor
  nnoremap <silent> <buffer> ?
        \ :for [key, value] in g:custom_defx_mappings <BAR>
        \ echo '' . key . ': ' . value <BAR>
        \ endfor<CR>
endfunction

augroup custom_defx
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_defx()
  autocmd BufEnter * call s:open_defx_if_directory()
  autocmd BufLeave,BufWinLeave \[defx\]* silent call defx#call_action('add_session')
  autocmd FileType defx setlocal nonumber norelativenumber
augroup end

" }}}
" Package: fzf and fzf preview {{{

" When in preview window, the following key mappings are relevant:
" <C-s>
"   - Toggle window size of fzf, normal size and full-screen
" <C-d>
"   - Preview page down
" <C-u>
"   - Preview page up
" <C-t> or ?
"   - Toggle Preview
" <C-x>, <C-v>, <C-t>: open in split, vert, and tab

let g:fzf_colors = {
      \ 'fg': ['fg', 'Normal'],
      \ 'bg': ['bg', 'Normal'],
      \ 'hl': ['fg', 'Comment'],
      \ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+': ['fg', 'Statement'],
      \ 'info': ['fg', 'PreProc'],
      \ 'border': ['fg', 'Ignore'],
      \ 'prompt': ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker': ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header': ['fg', 'Comment'],
      \ }

" Execute fzf command, but avoid doing so in a defx buffer
function! s:fzf_avoid_defx(command)
  if (expand('%') =~# 'defx' && winnr('$') > 1)
    execute "normal! \<c-w>\<c-w>"
  endif
  execute a:command
endfunction

let g:fzf_preview_default_key_bindings =
      \ 'ctrl-e:preview-page-down,ctrl-y:preview-page-up,?:toggle-preview'
let $FZF_DEFAULT_OPTS = '-m --bind '
      \ . g:fzf_preview_default_key_bindings . ' '
      \ . '--reverse '
      \ . '--prompt="> " '
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude ".git"'

" Floating window
let g:fzf_layout = { 'window': {
      \ 'width': 0.9,
      \ 'height': 0.6,
      \ 'yoffset': 0.9,
      \ 'highlight': 'Ignore',
      \ } }

let g:fzf_action = {
      \ 'ctrl-o': 'edit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }

" }}}
" Package: vim-tex {{{

let g:vimtex_compiler_latexmk = {'callback' : v:false}
let g:tex_flavor = 'latex'
let g:vimtex_imaps_enabled = v:false
let g:vimtex_doc_handlers = ['MyVimTexDocHandler']

function! MyVimTexDocHandler(context)
  " Function called with using :VimtexDocPackage
  " to pull up package documentation
  call vimtex#doc#make_selection(a:context)
  if !empty(a:context.selected)
    execute '!texdoc ' . a:context.selected . ' &'
  endif
  return 1
endfunction

" }}}
" Package: sandwich {{{

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

" Keymappings set in keymappings section
let g:textobj_sandwich_no_default_key_mappings = v:true

" }}}
" Package: nvim-autopairs {{{

function! s:init_nvim_autopairs()
lua << EOF
local ok, _ = pcall(require, 'nvim-autopairs')
if not ok then
  print('nvim-autopairs does not exist, skipping...')
  return
end
local npairs = require'nvim-autopairs'
local Rule   = require'nvim-autopairs.rule'
npairs.setup({
  disable_filetype = { "TelescopePrompt" },
})
npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
  Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
  Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
}
EOF
endfunction

augroup custom_nvim_autopairs
  autocmd!
  autocmd VimEnter * call s:init_nvim_autopairs()
augroup end

" }}}
" Package: zen-mode.nvim {{{

function! s:init_zen_mode()
  if !exists('g:loaded_commentary')
    echom 'ts context commentstring does not exist, skipping...'
    return
  endif
lua << EOF
local ok, _ = pcall(require, 'zen-mode')
if not ok then
  print('zen-mode does not exist, skipping...')
  return
end
require'zen-mode'.setup {
  window = {
    backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an absolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    -- * a function that returns the width or the height
    width = 120, -- width of the Zen window
    height = 1, -- height of the Zen window
    -- by default, no options are changed for the Zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      -- signcolumn = "no", -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
    gitsigns = { enabled = false }, -- disables git signs
    tmux = { enabled = false }, -- disables the tmux statusline
    -- this will change the font size on kitty when in zen mode
    -- to make this work, you need to set the following kitty options:
    -- - allow_remote_control socket-only
    -- - listen_on unix:/tmp/kitty
    kitty = {
      enabled = false,
      font = "+4", -- font size increment
    },
  },
  -- callback where you can add custom code when the Zen window opens
  on_open = function(win)
  end,
  -- callback where you can add custom code when the Zen window closes
  on_close = function()
  end,
}
EOF
endfunction

augroup custom_zenmode
  autocmd!
  autocmd VimEnter * call s:init_zen_mode()
augroup end

" }}}
" Package: nvim-repl {{{

let g:repl_filetype_commands = {
      \ 'bash': 'bash',
      \ 'javascript': 'node',
      \ 'python': 'bpython -q',
      \ 'sh': 'sh',
      \ 'vim': 'nvim --clean -ERZM',
      \ 'zsh': 'zsh',
      \ }

let g:repl_default = &shell

" }}}
" Package: vim-filetype-formatter {{{

let g:vim_filetype_formatter_verbose = v:false
let g:vim_filetype_formatter_ft_no_defaults = []
let g:vim_filetype_formatter_commands = {
      \ 'python': 'black -q - | isort -q - | docformatter -',
      \ }

" }}}
" Package: keywordprg helpers (vim-keywordprg-commands, etc) {{{

let g:vim_keywordprg_commands = {
      \ }
" NOTE: latex is handled by vimtex

augroup custom_keywordprg
  autocmd FileType markdown,rst,tex,txt setlocal keywordprg=:DefEng
  autocmd FileType python setlocal keywordprg=:Pydoc
  autocmd FileType typescript,typescriptreact setlocal keywordprg=:DD\ javascript
  autocmd FileType terraform setlocal keywordprg=:DD\ terraform
augroup end

" }}}
" Package: misc global var config {{{

" Python: disable python 2 support
let g:loaded_python_provider = v:true

" Markdown:
let g:markdown_fenced_languages = [
      \ 'bash=sh',
      \ 'python',
      \ ]

" Netrw: disable completely
let g:loaded_netrw= v:true
let g:netrw_loaded_netrwPlugin= v:true
let g:netrw_nogx = v:true

" UndoTree:
let g:undotree_SetFocusWhenToggle = v:true
let g:undotree_WindowLayout = 3

" QFEnter:
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']
" do not copy quickfix when opened in new tab
let g:qfenter_enable_autoquickfix = v:false
" automatically move QuickFix window to fill entire bottom screen
augroup custom_quickfix
  autocmd FileType qf wincmd J
augroup end

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

" Python: highlighting
let g:python_highlight_space_errors = v:false
let g:python_highlight_all = v:true

" Json: highlighting
let g:vim_json_syntax_conceal = v:false

" Ferret:
" disable default mappings
let g:FerretMap = v:false

" VimJavascript:
let g:javascript_plugin_flow = v:false

" IndentLines:
let g:indentLine_enabled = v:false  " indentlines disabled by default

" BulletsVim:
let g:bullets_enabled_file_types = [
      \ 'gitcommit',
      \ 'markdown',
      \ 'markdown.mdx',
      \ 'scratch',
      \ 'text',
      \ 'rst',
      \ ]
let g:bullets_outline_levels = ['num', 'std-']

" RequirementsVim: filetype detection (begin with requirements)
let g:requirements#detect_filename_pattern = 'requirements.*\.txt'

" QuickScope: great plugin helping with f and t
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 10000

" Go: random stuff
let g:go_version_warning = v:false

" HexMode: configure hex editing
" relevant command: Hexmode
let g:hexmode_patterns = '*.bin,*.exe,*.dat,*.o'
let g:hexmode_xxd_options = '-g 2'

" Syntax Omni Completion:
let g:omni_syntax_use_single_byte = v:false
let g:omni_syntax_use_iskeyword_numeric = v:false

" LocListFollow:
let g:loclist_follow = 1
let g:loclist_follow_modes = 'n'
let g:loclist_follow_target = 'previous'

" Makefile: global variable to prevent syntax highlighting of commands
let g:make_no_commands = 1

augroup custom_loclistfollow
  autocmd!
  autocmd FileType man,help LoclistFollowToggle
augroup end

" }}}
" Tidbits: helpful hints / temporary fixes {{{

" This is my Neovim configuration file. Hopefully you enjoy using it as much
" as me! I use Linux Mint / Ubuntu 18.04, but this will probably work with
" most Linux-based OS's.
"
" Installation:
"   1. Put file in correct place within filesystem
"     Soft-link this file to ~/.config/nvim/init.vim
"   2. Install Vim-Packager (a great plugin manager)
"   3. Open nvim (hint: type nvim at command line and press enter :p)
"   4.     :PackInstall
"   5.     :PackUpdate
"   6.     :PackUpgrade

" TextObjectSelection:
" object-select OR text-objects
" delete the inner (...) block where the cursor is.
" dib ( or 'di(' )
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

" Temporary Fixes

" Fix weird package issues with nightly. Periodically try removing these
" explicit packadd statements and see if things have fixed themselves.
packadd coc-jedi.git

" }}}
" Samuel Roeca's '~/.config/nvim/init.vim'. Toggle folds with 'za'.
