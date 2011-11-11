" Setup for VIM: The number one text editor!
" -----------------------------------------------------------------------------
" Author: Karl Yngve Lerv�g
"
"{{{1 Activate pathogen
if !exists("pathogen_loaded")
  source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
  call pathogen#infect()
  let pathogen_loaded = 1
endif

"{{{1 All the general options
filetype plugin indent on
syntax on
set nocompatible
set history=1000
set confirm
set winaltkeys=no
set wildmode=longest,list:longest
set ruler
set lazyredraw
set mouse=
set ignorecase
set smartcase
if &foldmethod == ""
  set foldmethod=syntax
endif
set foldlevel=0
set foldcolumn=0
set hidden
set modelines=5
set tags+=tags;/
set fillchars=fold:\ 
set complete+=U
set thesaurus+=~/.vim/thesaurus/mythesaurus.txt
set spellfile+=~/.vim/spell/mywords.latin1.add
set spellfile+=~/.vim/spell/mywords.utf-8.add
set showmatch
set matchtime=2
set matchpairs+=<:>
set nohlsearch
set incsearch
set scrolloff=10
set showcmd
set columns=80
set colorcolumn=80
set autoindent
set nocindent
set softtabstop=2
set shiftwidth=2
set textwidth=79
set formatoptions=tcrq1n
set formatlistpat=^\\s*\\(\\(\\d\\+\\\|[a-z]\\)[.:)]\\\|[-*]\\)\\s\\+
set formatprg=par\ -w79jrq
set fileformat=unix
set wrap linebreak showbreak=\ 
set smarttab
set expandtab
set spelllang=en_gb
set diffopt=filler,context:4,foldcolumn:2,horizontal
set completeopt=menuone,menu,longest
set grepprg=ack-grep
set list lcs=tab:>\ ,trail:\ ,nbsp:%,extends:>,precedes:<
set cursorline
set autochdir

" Some lisp additions
set lispwords+=alet,alambda,dlambda,aif

"{{{1 Statusline
set laststatus=2
set statusline=[%n]\ %t                         " tail of the filename
set statusline+=\ %m                            " modified flag
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}                          " file format
set statusline+=%Y                              " filetype
set statusline+=%H                              " help file flag
set statusline+=%R]                             " read only flag
set statusline+=%q                              " quickfix-tag
set statusline+=%w                              " preview-tag
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%=                              " left/right separator
set statusline+=(%v,                            " cursor column
set statusline+=%l/%L)                          " cursor line/total lines
set statusline+=\ %P                            " percent through file

"{{{1 Gui and colorscheme options
if has("gui_running")
  set lines=56
  set guioptions=aegiLt
  set guifont=Monospace\ 9
endif

set background=dark
let g:solarized_contrast="high"
colorscheme solarized

"{{{1 OS-specific options (including backup and undofile options)
set backup
if has("unix")
  set clipboard=autoselect
  set backspace=indent,eol,start
  set backupdir=$HOME/.vim/backup
  set directory=$HOME/.vim/backup
elseif has("win32")
  source $VIMRUNTIME/mswin.vim
  set backupdir=$VIM/backup
  set directory=$VIM/backup
endif

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
end

"{{{1 Autocommands
"{{{2 General autocommands
augroup GeneralAutocommands
  autocmd!

  " Reload settings when changed
  autocmd bufwritepost .vimrc source $MYVIMRC
  autocmd bufwritepost .vimrc :normal zx

  " Set omnifunction if it is not already specified
  if exists("+omnifunc")
    autocmd Filetype *
          \ if &omnifunc == "" |
          \   setlocal omnifunc=syntaxcomplete#Complete |
          \ endif
  endif

  " Create directory if it does not exist when opening a new file
  autocmd BufNewFile  * :call EnsureDirExists()

  " When editing a  file, always jump to the last  known cursor position. Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

"{{{2 Specific autocommands
augroup SpecificAutocommands
  autocmd!

  " Bash scripts
  au BufReadPost *.sh let g:sh_fold_enabled=1

  " Textfiles
  au BufReadPost *.txt setlocal textwidth=78
  au BufReadPost *.txt setlocal formatoptions-=c

  " Fortran
  au BufReadPost *.f90 set foldmethod=syntax

  " MATLAB
  au BufReadPost *.m set foldmethod=manual

  " C++
  au BufReadPost *.c++ setlocal cindent

  " LaTeX
  au BufReadPost *.tex call LaTeXSettings()

  " Python
  au FileType python syn keyword pythonDecorator True None False self

  " Makefile
  au FileType make set nolist
augroup END
"{{{1 Key mappings (general)
" Exit insert mode
inoremap jkj <Esc>

" Open certain files with ,v...
map ,vv :e $MYVIMRC<cr>
map ,vs :e  ~/.vim/snippets/<cr>

" Mappings for switching and closing buffers
nnoremap <silent> <C-p> :bp<CR>
nnoremap <silent> <C-n> :bn<CR>
nnoremap <C-U> :bd<CR>

" Mappings for controlling the error window
map ,ec :botright cope<cr>
map ,en :cn<cr>
map ,ep :cp<cr>

" Spell checking
let sc_on = 0
nnoremap <leader>ss :let sc_on = SpellCheck(sc_on)<CR>
nnoremap <leader>sq :ChooseLanguage()<CR>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Navigate folds
nmap ,, zcjzo
nmap ,. zckzo
nmap <space> za

" Visual shifting
vnoremap < <gv
vnoremap > >gv

" Other stuff
noremap Y y$
imap <silent> <c-r><c-d> <c-r>=strftime("%e %b %Y")<CR>
imap <silent> <c-r><c-t> <c-r>=strftime("%l:%M %p")<CR>
map <F12> ggVGg? " encypt the file (toggle)

" Make it possible to save as sudo
cmap w!! %!sudo tee > /dev/null %

map ,gg :grep <C-R>=expand(expand("<cword>") . " " . expand("%:h"))<CR><CR>
map ,go :botright cwindow<CR>
map ,gp :cprev<CR>
map ,gn :cnext<CR>

"command Preview ...

"{{{1 Plugin settings
"{{{2 Ack settings
let g:ackprg="ack-grep -H --nocolor --nogroup --column"
let g:ackhighlight=1

"{{{2 Command-t
nmap <silent> <Leader>tt :CommandT<CR>
nmap <silent> <Leader>t :CommandT 

"{{{2 ConqueTerm
let g:ConqueTerm_SendVisKey = ',cc'
let g:ConqueTerm_SendFileKey = ',ca'
let g:ConqueTerm_ExecFileKey = ',cf'
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_TERM = 'xterm'

"{{{2 delimitMate
" General options
let delimitMate_expand_space       = 1
let delimitMate_excluded_regions   = "Comments,String"
let delimitMate_matchpairs         = "(:),[:],{:}"
let delimitMate_quotes             = "\" '"
let delimitMate_excluded_ft        = "txt"

" Tweak for some file types
au FileType vim  let b:delimitMate_quotes = "'"
au FileType lisp let b:delimitMate_quotes = '"'

"{{{2 Enhanced commentify settings
let g:EnhCommentifyUserBindings='Yes'

"{{{2 Gundo
let g:gundo_width=60
map <S-u> :GundoToggle<cr>

"{{{2 NERDCommenter
let NERDBlockComIgnoreEmpty = 0
let NERDCommentWholeLinesInVMode=1
let NERDCreateDefaultMappings=0
map <C-A-c> <plug>NERDCommenterToggle

"{{{2 NERDTree
map ,nt :NERDTreeToggle<CR>
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.hg$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1

"{{{2 Supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-n>"
let g:SuperTabRetainCompletionDuration = "session"
let g:SuperTabLongestEnhanced = 1

"{{{2 syntactics
let g:syntastic_auto_loc_list = 2
let g:syntastic_stl_format = '[%E{Err: %e}%B{, }%W{Warn: %w}]'
let g:syntastic_disabled_filetypes = ['tex']
let g:syntastic_enabled = 1

" Set flags for fortran compilation
let g:syntastic_fortran_flags = ' -fdefault-real-8'
let g:syntastic_fortran_flags .= ' -Wall -Wextra'
let g:syntastic_fortran_flags .= ' -J/tmp'
let g:syntastic_fortran_flags .= ' -I' . expand('%:h')
let g:syntastic_fortran_flags .= ' -I' . expand('%:h') . '/..'
let g:syntastic_fortran_flags .= ' -I' . expand('~/') .
      \ 'koder/levelZ/objects/debug_gfortran_Linux'

function! SyntasticToggle()
  if g:syntastic_enabled
    SyntasticDisable
    let g:syntastic_enabled = 0
  else
    SyntasticEnable
    let g:syntastic_enabled = 1
  endif
endfunction
map <leader>st :call SyntasticToggle()<cr>

"{{{2 Tabular
nmap <silent> <Leader>tl :Tab<cr>

"{{{2 VCSCommand
let VCSCommandSplit = 'horizontal'
if v:version < 700
  let VCSCommandDisableAll='1'
end
map ,cc :call ChooseVCSCommandType()<cr>

"{{{1 Functions
function! LaTeXSettings()                                                 "{{{2
  " For all tex files use forward slash in filenames
  setlocal shellslash nocindent
  setlocal iskeyword+=:

  " Start with fold open and center screen
  silent! normal zO zz
endfunction
function! EnsureDirExists ()                                              "{{{2
  let dir = expand("%:h")
  if !isdirectory(dir)
    call AskQuit("Directory '" . dir . "' doesn't exist.", "&Create it?")
    try
      call mkdir(dir, 'p')
    catch
      call AskQuit("Can't create '" . dir . "'", "&Continue anyway?")
    endtry
  endif
endfunction
function! SpellCheck(sc_on)                                               "{{{2
  if a:sc_on
    echo "Spell checking turned off!"
    set nospell
    return 0
  else
    echo "Spell checking turned on!"
    set spell
    return 1
  endif
endfunction
function! ChooseVCSCommandType()                                          "{{{2
  let choice = confirm("Choose VCS Type", "&CVS\n&Mercurial")
  if choice == 1
    let b:VCSCommandVCSType="CVS"
  elseif choice == 2
    let b:VCSCommandVCSType="Mercurial"
  endif
endfunction
function! ChooseLanguage()                                                "{{{2
  let choice =
        \ confirm("Choose Language",
        \ "&Bokmaal\n&Nynorsk\nEnglish &GB\nEnglish &USA")
  if choice == 1
    set spelllang=nb
  elseif choice == 2
    set spelllang=nn
  elseif choice == 3
    set spelllang=en_us
  elseif choice == 4
    set spelllang=en_gb
  endif
endfunction
function! ChooseMakePrg()                                                 "{{{2
  let choice = confirm("Choose make program" , "&Python\n&Makefile")
  if choice == 1
    set makeprg=python\ %
  elseif choice == 2
    set makeprg=make
  endif
endfunction
function! CreateTags()                                                    "{{{2
  !silent! lcd %:h
  let choice = confirm("What kind of tags?" , "&Stop\n&C++\n&Fortran" , 1)
  if choice == 2
    silent execute "!ctags -o tagsmenu --c++-kinds=cf *.cpp"
    silent execute "!ctags *.cpp"
    silent execute "!sed -i '/TAG/d' tagsmenu"
  elseif choice == 3
    silent execute "!ctags -o tagsmenu *.f90"
    silent execute "!ctags *.f90"
    silent execute "!sed -i '/TAG/d' tagsmenu"
  endif
  silent! lcd -
endfunction
function! ShowFunctions()                                                 "{{{2
  30vsplit tagsmenu
  set nowrap
  setlocal ts=99
  map <CR> 0ye:bd<CR>:tag <C-R>"<CR>
endfunction
function! UpdateCopyrightLine()                                           "{{{2
  let copyrights = {
    \ 'Copyright (c) .\{-}, \d\d\d\d-\zs\d\d\d\d' : 'strftime("%Y")',
    \}

  for [copyright, year] in items(copyrights)
    silent! execute "'[,']s/" . copyright . '/\= ' . replacement . '/'
  endfor
endfunction
function! AskQuit (msg, proposed_action)                                  "{{{2
  if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
    exit
  endif
endfunction
"{{{1 Footer
"
" -----------------------------------------------------------------------------
" Copyright, Karl Yngve Lerv�g (c) 2008 - 2011
" -----------------------------------------------------------------------------
" vim: foldmethod=marker:ff=unix
"
