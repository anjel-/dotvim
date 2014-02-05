" Setup for VIM: The number one text editor!
" -----------------------------------------------------------------------------
" Author: Karl Yngve Lervåg

"{{{1 Preamble | Load packages

set nocompatible
if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleLocal ~/.vim/bundle_local/

" Load packages
" {{{2 Neobundle, Unite, and neocomplete
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'name'  : 'neovimproc',
      \ 'build' : {
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'Shougo/neocomplete', {
      \ 'vim_version' : '7.3.885'
      \ }

" {{{2 Projects I participate in
NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box.git', { 'type__protocol' : 'ssh', }
NeoBundle 'lervag/vim-latex.git', { 'type__protocol' : 'ssh' }

" {{{2 Other plugins and scripts
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'
NeoBundle 'bogado/file-line'
NeoBundle 'dahu/vim-fanfingtastic'
NeoBundle 'ervandew/screen'
NeoBundle 'ervandew/supertab'
NeoBundle 'git://repo.or.cz/vcscommand.git'
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'Peeja/vim-cdo'
NeoBundle 'rbtnn/vimconsole.vim'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'sjl/clam.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'sjl/splice.vim'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-fugitive', {
      \ 'augroup' : 'fugitive',
      \ }
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'tyru/current-func-info.vim'
NeoBundle 'vim-ruby/vim-ruby', {
      \ 'autoload' : {
        \ 'filetypes' : ['rb'],
        \ },
      \ }

" }}}2

" Temporary
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-reload'

" Call on_source hook when reloading .vimrc.
if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif

filetype plugin indent on

NeoBundleCheck

"{{{1 General options

"{{{2 Basic options
set history=1000
set confirm
set winaltkeys=no
set ruler
set lazyredraw
set mouse=
set hidden
set modelines=5
set tags=./tags,./.tags,./../*/.tags,./../*/tags
set fillchars=fold:\ ,diff:⣿
if has('gui_running')
  set diffopt=filler,foldcolumn:0,context:4,vertical
else
  set diffopt=filler,foldcolumn:0,context:4
endif
set matchtime=2
set matchpairs+=<:>
set showcmd
set backspace=indent,eol,start
set autoindent
set fileformat=unix
set spelllang=en_gb
set list
set listchars=tab:▸\ ,nbsp:%,extends:❯,precedes:❮
set cursorline
set autochdir
set cpoptions+=J
set autoread
set wildmode=longest,list:longest

if executable("ack-grep")
  set grepprg=ack-grep\ --nocolor
endif

"{{{2 Folding
if &foldmethod == ""
  set foldmethod=syntax
endif
set foldlevel=0
set foldcolumn=0
set foldtext=TxtFoldText()

function! TxtFoldText()
  let level = repeat('-', min([v:foldlevel-1,3])) . '+'
  let title = substitute(getline(v:foldstart), '{\{3}\d\?\s*', '', '')
  let title = substitute(title, '^["#! ]\+', '', '')
  return printf('%-4s %-s', level, title)
endfunction

" Set foldoption for bash scripts
let g:sh_fold_enabled=7

" Navigate folds
nnoremap zf zMzvzz
nnoremap zj zcjzvzz
nnoremap zk zckzvzz
nnoremap <space> za
vnoremap <space> za

"{{{2 Tabs, spaces, wrapping
set softtabstop=2
set shiftwidth=2
set textwidth=79
set columns=80
if v:version >= 703
  set colorcolumn=81,82,83
end
set smarttab
set expandtab
set wrap
set linebreak
let &showbreak = '+++ '
set formatoptions+=rnl1j
set formatlistpat=^\\s*\\(\\(\\d\\+\\\|[a-z]\\)[.:)]\\\|[-*]\\)\\s\\+

"{{{2 Backup and Undofile
set noswapfile
set nobackup

" Sets undo file directory
if v:version >= 703
  set undofile
  set undolevels=1000
  set undoreload=10000
  if has("unix")
    set undodir=$HOME/.vim/undofiles
  elseif has("win32")
    set undodir=$VIM/undofiles
  endif
  if !isdirectory(&undodir)
    call mkdir(&undodir)
  endif
end

"{{{2 Spellfile, thesaurus, similar
set thesaurus+=~/.vim/thesaurus/mythesaurus.txt
set spellfile+=~/.vim/spell/mywords.latin1.add
set spellfile+=~/.vim/spell/mywords.utf-8.add

"{{{2 Gui and colorscheme options
syntax on
set background=light
if has("gui_running")
  set lines=56
  set columns=82
  set guioptions=aeci
  set guifont=Inconsolata-g\ Medium\ 9
else
  set t_Co=256
  set background=dark
endif
if neobundle#is_sourced('vim-colors-solarized')
  colorscheme solarized
  call togglebg#map("<F6>")
endif

" Custom highlighting for Matchparen
highlight clear MatchParen
highlight MatchParen gui=bold guibg=#bfb

" Custom highlighting for spell
highlight clear SpellBad SpellCap SpellRare SpellLocal
highlight SpellBad   gui=bold guibg=#faa
highlight SpellCap   gui=bold guibg=#faf
highlight SpellRare  gui=bold guibg=#aff
highlight SpellLocal gui=bold guibg=#ffa

"{{{2 Searching and movement
set ignorecase
set smartcase
set nohls
set incsearch
set showmatch

set scrolloff=10
set virtualedit+=block

runtime macros/matchit.vim

noremap j gj
noremap k gk
"}}}2

"{{{1 Completion

set complete+=U,s,k,kspell,d
set completeopt=longest,menu,preview

" Note: See also under plugins like supertab and neocomplete

"{{{1 Statusline (Airline plugin)

set noshowmode
set laststatus=2

" Separators
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''

" Symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ' '
let g:airline_symbols.readonly = ''
let g:airline_symbols.paste = 'Þ'

" Extensions
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 1

" Theme and customization
let g:airline_section_z = '%3p%% %l:%c'
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

"{{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Set omnifunction if it is not already specified
  autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif
augroup END

"{{{1 Key mappings

noremap  H      ^
noremap  L      g_
noremap  <f1>   <nop>
inoremap <esc>  <nop>
inoremap jk     <esc>
inoremap <f1>   <nop>
nnoremap  Y     y$
nnoremap J      mzJ`z
nnoremap <c-u>  :bd<cr>
nnoremap gb     :bnext<cr>
nnoremap gB     :bprevious<cr>
nnoremap dp     dp]c
nnoremap do     do]c

" Search for todos
nmap <silent> gt :call search('todo')<cr>zf

" Shortcuts for some files
map <leader>ev :e ~/.vim/vimrc<cr>
map <leader>ez :e ~/.dotfiles/zshrc<cr>
map <leader>sv :source $MYVIMRC<cr>

" Make it possible to save as sudo
cmap w!! %!sudo tee > /dev/null %

" Open url in browser
map <silent> gx <Plug>(open-in-browser)

" Change word under cursor
nnoremap ,r :'{,'}s/\<<c-r>=expand('<cword>')<cr>\>/
nnoremap ,R :%s/\<<c-r>=expand('<cword>')<cr>\>/

"{{{1 Plugin settings

"{{{2 Ack settings
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

"{{{2 Clam
if !has('gui_running')
  let g:clam_winpos = 'topleft'
endif

"{{{2 CtrlP
let g:ctrlp_custom_ignore = {}
let g:ctrlp_custom_ignore.dir =
      \ '\vCVS|\.(git|hg|vim\/undofiles|vim\/backup)$'
let g:ctrlp_custom_ignore.file =
      \ '\v\.(aux|pdf|gz)$|documents\/ntnu\/phd'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_map = ''
let g:ctrlp_match_window = 'top,order:ttb,max:25'
let g:ctrlp_mruf_exclude  = '\v\.(pdf|aux|bbl|blg)$'
let g:ctrlp_mruf_exclude .= '|share\/vim.*doc\/'
let g:ctrlp_mruf_exclude .= '|\.neobundle\/'
let g:ctrlp_mruf_exclude .= '|\/\.git\/'
let g:ctrlp_mruf_exclude .= '|journal\.txt$'
let g:ctrlp_root_markers = ['CVS']
let g:ctrlp_show_hidden = 0

nnoremap <silent> <space><space> :CtrlPMRUFiles<cr>
nnoremap <silent> <space>h :CtrlP /home/lervag<cr>
nnoremap <silent> <space>v :CtrlP /home/lervag/.vim<cr>
nnoremap <silent> <space>q :CtrlPQuickfix<cr>

"{{{2 vim-easy-align
let g:easy_align_bypass_fold = 1
map ga <Plug>(EasyAlign)
map gA <Plug>(LiveEasyAlign)

"{{{2 Fanfingtastic
let g:fanfingtastic_fix_t = 1
let g:fanfingtastic_use_jumplist = 1

"{{{2 Gundo
let g:gundo_width=60
let g:gundo_preview_height=20
let g:gundo_right=1
let g:gundo_close_on_revert=1
map <silent> <F5> :GundoToggle<cr>

"{{{2 latex
let g:latex_enabled = 1
let g:latex_viewer = 'mupdf -r 95'
let g:latex_default_mappings = 1
let g:latex_errorformat_ignore_warnings =
      \ [
      \ 'Underfull',
      \ 'Overfull',
      \ 'specifier changed to',
      \ 'Setting ''defernumbers=true',
      \ 'Editor ''',
      \ ]

let g:LatexBox_latexmk_async = 1
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_Folding = 1
let g:LatexBox_viewer = 'mupdf -r 95'
let g:LatexBox_quickfix = 2
let g:LatexBox_split_resize = 1

"{{{2 Neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1

" Plugin key-mappings
inoremap <expr> <C-g> neocomplete#undo_completion()
inoremap <expr> <C-l> neocomplete#complete_common_string()

" Enable omni completion
augroup neocomplete_omni_complete
  autocmd!
  autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType markdown   setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
augroup END

" Define keyword and omni patterns
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'
let g:neocomplete#keyword_patterns.tex = '\h\w\+'
let g:neocomplete#force_omni_input_patterns.tex =
      \ '\v\\\a*(ref|cite)\a*([^]]*\])?\{(|[^}]*,)'

"{{{2 Rainbox Parentheses
nnoremap <leader>R :RainbowParenthesesToggle<cr>
let g:rbpt_max = 14
let g:rbpt_colorpairs = [
    \ ['033', '#268bd2'],
    \ ['037', '#2aa198'],
    \ ['061', '#6c71c4'],
    \ ['064', '#859900'],
    \ ['125', '#d33682'],
    \ ['136', '#b58900'],
    \ ['160', '#dc322f'],
    \ ['166', '#cb4b16'],
    \ ['234', '#002b36'],
    \ ['235', '#073642'],
    \ ['240', '#586e75'],
    \ ['241', '#657b83'],
    \ ['244', '#839496'],
    \ ['245', '#93a1a1'],
    \ ]

if neobundle#is_sourced('rainbow_parentheses.vim')
  augroup RainbowParens
    au!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
  augroup END
endif

"{{{2 Screen
let g:ScreenImpl = "GnuScreen"
let g:ScreenShellTerminal = "xfce4-terminal"
let g:ScreenShellActive = 0

" Dynamic keybindings
function! s:ScreenShellListenerMain()
  if g:ScreenShellActive
    nmap <silent> <C-c><C-c> <S-v>:ScreenSend<CR>
    vmap <silent> <C-c><C-c> :ScreenSend<CR>
    nmap <silent> <C-c><C-a> :ScreenSend<CR>
    nmap <silent> <C-c><C-q> :ScreenQuit<CR>
    if exists(':C') != 2
      command -nargs=? C :call ScreenShellSend('<args>')
    endif
  else
    nmap <C-c><C-a> <Nop>
    vmap <C-c><C-c> <Nop>
    nmap <C-c><C-q> <Nop>
    nmap <silent> <C-c><C-c> :ScreenShell<cr>
    if exists(':C') == 2
      delcommand C
    endif
  endif
endfunction

" Initialize and define auto group stuff
nmap <silent> <C-c><C-c> :ScreenShell<cr>
augroup ScreenShellEnter
  au USER * :call <SID>ScreenShellListenerMain()
augroup END
augroup ScreenShellExit
  au USER * :call <SID>ScreenShellListenerMain()
augroup END

"{{{2 Splice
let g:splice_initial_mode = "grid"
let g:splice_initial_layout_grid = 1
let g:splice_initial_diff_grid = 1

"{{{2 Supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabRetainCompletionDuration = "session"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabCrMapping = 0

augroup Supertab
  autocmd!
  autocmd FileType fortran call SuperTabSetDefaultCompletionType("<c-n>")
  autocmd FileType text    call SuperTabSetDefaultCompletionType("<c-n>")
augroup END

"{{{2 syntactics
let g:syntastic_auto_loc_list = 2
let g:syntastic_always_populate_loc_list=1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['tex'] }
let g:syntastic_fortran_compiler_options = " -fdefault-real-8"
let g:syntastic_fortran_include_dirs = [
                            \ '../obj/gfortran_debug',
                            \ '../objects/debug_gfortran',
                            \ '../thermopack/objects/debug_gfortran_Linux',
                            \ ]
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

"{{{2 Ultisnips
let g:UltiSnipsJumpForwardTrigger="<m-u>"
let g:UltiSnipsJumpBackwardTrigger="<s-m-u>"
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsSnippetsDir = "~/.vim/bundle_local/personal/snippets"
let g:UltiSnipsSnippetDirectories = ["snippets"]
map <leader>es :UltiSnipsEdit<cr>

"{{{2 Unite
let g:unite_enable_start_insert = 1
let g:unite_enable_short_source_names = 1
let g:unite_source_buffer_time_format = "(%H:%M) "
let g:unite_source_file_mru_time_format = "(%d.%m %H:%M) "

if neobundle#is_sourced('unite.vim')
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  call unite#custom#source('command',  'matchers', 'matcher_fuzzy')
  call unite#custom#source('grep',     'matchers', 'matcher_fuzzy')
  call unite#custom#source('outline',  'matchers', 'matcher_fuzzy')
  call unite#custom#source('find',     'matchers', 'matcher_fuzzy')
  call unite#custom#source('function', 'matchers', 'matcher_fuzzy')
  call unite#custom#source('line',     'matchers', 'matcher_fuzzy')
  call unite#custom#source('vimgrep',  'matchers', 'matcher_fuzzy')
endif

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  let b:SuperTabDisabled=1
  imap <buffer> jk      <Plug>(unite_insert_leave)
  imap <buffer> <c-c>   <Plug>(unite_exit)
  imap <buffer> <c-j>   <Plug>(unite_select_next_line)
  imap <buffer> <c-k>   <Plug>(unite_select_previous_line)
endfunction

" Unite mappings
nnoremap <silent> <space>c :Unite -buffer-name=commands -no-split command<cr>
nnoremap <silent> <space>u :Unite
      \ -buffer-name=neobundle
      \ -no-start-insert
      \ -no-split
      \ -max-multi-lines=1
      \ -multi-line
      \ -silent
      \ -log
      \ neobundle/update:all<cr>

"{{{2 VCSCommand
if !has('gui_running')
  let VCSCommandSplit = 'horizontal'
endif
if v:version < 700
  let VCSCommandDisableAll='1'
end

"{{{2 vim-ruby
let g:ruby_fold=1

"}}}2

"}}}1

" vim: fdm=marker
