" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
" }
"

" plugins {
"
" plug begin {
call plug#begin('~/.config/nvim/plugged')

    " TODO cf dirvish
    Plug 'scrooloose/nerdtree'
    " TODO investigate
    Plug 'Xuyuanp/nerdtree-git-plugin'

    " linting
    Plug 'w0rp/ale'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'altercation/vim-colors-solarized'

    Plug 'tpope/vim-projectionist'
    Plug 'tpope/vim-unimpaired'

    " fuzzy finders
    " macrobatics does not work with ctrlp
    " TODO cf fzf.vim
    " Plug 'kien/ctrlp.vim'
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

    " TODO
    "Plug 'ivan-cukic/vim-ctrlp-switcher'
    Plug 'mattn/ctrlp-mark'

    Plug 'scrooloose/nerdcommenter'


    " replaces surround
    Plug 'machakann/vim-sandwich'

    " session management
    Plug 'tpope/vim-obsession'

    " git related
    " cf vim-signify
    Plug 'airblade/vim-gitgutter'
    Plug 'rhysd/git-messenger.vim'
    Plug 'tpope/vim-fugitive'
    " following 2 needed to make symlinks work in fugitive
    Plug 'moll/vim-bbye' " optional dependency for symlink
    Plug 'aymericbeaumet/vim-symlink'

    Plug 'cespare/vim-toml'

    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    " view marks
    Plug 'kshenoy/vim-signature'

    " unix commands like Move
    Plug 'tpope/vim-eunuch'


"    Plug 'ryanoasis/vim-devicons'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'

    Plug 'mattn/emmet-vim'

    " replaces ack.vim
    Plug 'mhinz/vim-grepper'

    Plug 'janko/vim-test'

"    Plug 'ludovicchabant/vim-gutentags'
    " cf for lsp support https://github.com/liuchengxu/vista.vim
"    Plug 'majutsushi/tagbar'
    Plug 'liuchengxu/vista.vim'

    " cf vim-mundo
    Plug 'mbbill/undotree'

    " japanese text input
    Plug 'tyru/eskk.vim'

    Plug 'tpope/vim-abolish'

    " cf repmo and see if ;, suffice
    "use space to repeat motions!
    Plug 'spiiph/vim-space'

    Plug 'coderifous/textobj-word-column.vim'
    Plug 'wellle/targets.vim'

    Plug 'junegunn/vim-easy-align'
    Plug 'chrisbra/csv.vim'

    Plug 'svermeulen/vim-macrobatics'
    Plug 'junegunn/vim-peekaboo'

call plug#end()
" end plug }
" end plugins }

" basic {

" history {
" http://stackoverflow.com/questions/5700389/using-vims-persistent-undo
set backup                  " Backups are nice ...
set backupdir=~/.config/nvim/backup " looks like this is the default?
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undodir=~/config/nvim/undo
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
" end history }
" settings {
"
let mapleader = ','
" leader currently used up , (repeat motion backwards)
" keeping this mapping here instead of in mapping section for simplicity
nnoremap <silent> <Leader>; ,

set clipboard=unnamedplus

" show existing tab with 4 spaces width
set tabstop=4
" delete tabstop many spaces on backspace
set softtabstop=-1
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

set ignorecase
set smartcase

" Allow buffer switching without saving
set hidden

" on load fold code more than 2 deep
set foldlevelstart=2

" relative numbers, except for current line!
set number
set relativenumber

" vertical line at 80 chars
set colorcolumn=80
set cursorline
set cursorcolumn

set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic  whitespace

set tags^=./.git/tags;

set dictionary=/usr/share/dict/usa

colorscheme solarized

" default is 4000. in particular is nice for gitgutter
set updatetime=100

" TODO nonportable
"let g:solarized_termcolors=256
let g:solarized_termcolors=16


" TODO nonportable
" this is a venv created jus for neovim
let g:python3_host_prog = '~/.virtualenvs/py3nvim/bin/python'
" settings }

" mappings {
inoremap jj <Esc>

nnoremap Y y$

" The following two lines conflict with moving to top and
" bottom of the screen
map <S-H> gT
map <S-L> gt

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

cmap Tabe tabe

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

map <leader>eW :e<space>
map <leader>eS :sp<space>
map <leader>eV :vsp<space>
map <leader>eT :tabe<space>


" easy save
noremap <leader>w :w<CR>
noremap <leader>W :wa<CR>

noremap <leader>sp :sp<CR>
noremap <leader>vs :vs<CR>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" jump to parent fold. closes current fold, goes up, opens fold, goes down
" sometimes works better than [z
nnoremap zK zakjzak

" Toggle search highlighting
nmap <silent> <leader>/ :set invhlsearch<CR>

" https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
" j/k do gj unless have count. if count is > 5 then put in jumplist!
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" tab related {
" TODO make wrap
noremap <Leader>te :+tabmove<CR>
noremap <Leader>tb :-tabmove<CR>

" tag in new tab
" https://stackoverflow.com/questions/6069279/vim-open-tag-in-new-tab
nnoremap <silent><Leader>t<C-]> <C-w><C-]><C-w>T

" zoom. can just use <C-w>= to undo
" <C-w>z already taken by close window <C-w>m available....
noremap <leader><C-w>z <c-w>_ \| <c-w>\|

" end tab related }
"
" mappings }

" autocmds {
" absolute line numbers in insert mode, relative otherwise for easy movement
augroup numbertoggle
    autocmd!
    autocmd InsertLeave * set relativenumber
    autocmd InsertEnter   * set norelativenumber

    " show line numbers in help
    autocmd FileType help
                         \ setlocal number |
                         \ setlocal relativenumber
augroup END


augroup help_help
    autocmd!
    " https://vim.fandom.com/wiki/Learn_to_use_help
    autocmd FileType help  nnoremap <buffer> <CR> <C-]>
    autocmd FileType help  nnoremap <buffer> <BS> <C-T>
    " jump options
    autocmd FileType help  nnoremap <buffer> o /'\l\{2,\}'<CR>
    autocmd FileType help  nnoremap <buffer> O ?'\l\{2,\}'<CR>
    " jump subjects
    autocmd FileType help  nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
    autocmd FileType help  nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>
augroup END

" Always switch to the current file directory
" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" claim is autochdir can not play well with plugins
augroup setcwd
    autocmd!
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
augroup END

" https://vi.stackexchange.com/questions/18177/how-to-force-redraw-when-returning-to-command-line-from-command-line-history-win?rq=1
" if in command mode you do <C-f> to use edit command mode, then you <C-c> to
" exit editing, by default the history will stay visable in an annoying extra
" split. this autoremoves it
augroup my_cmdline_window
    autocmd!
    autocmd CmdWinEnter * nno  <buffer><expr><nowait>  <c-c>  '<c-c>'.timer_start(0, {-> execute('redraw')})[-1]
augroup END

augroup foldmethods
    autocmd!
    autocmd BufNewFile,BufRead *.py set foldmethod=indent
    autocmd BufNewFile,BufRead *.page set foldmethod=indent
augroup END

" end autocmds }

" Mimic Emacs Line Editing in Insert/command Mode {

cnoremap <C-A> <Home>
" https://unix.stackexchange.com/questions/408980/delete-to-end-of-command-line-in-vim
" Note that your suggested left-hand side clobbers the useful digraphs entry.
cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>

inoremap <C-A> <Home>
inoremap <C-E> <End>

inoremap <C-K> <Esc>lDa
inoremap <C-U> <Esc>d0xi

" end emacs mimic }

" Stupid shift key fixes {
if has('user_commands')
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wqa wqa<bang>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif
" end Stupid shift key fixes }

" statusline {
if has('statusline')
"The value of this option influences when the last window will have a
"status line:
    "0: never
    "1: only if there are at least two windows
    "2: always
set laststatus=2

" Broken down into easily includeable segments
set statusline=%<%f\                     " Filename
set statusline+=%w%h%m%r                 " Options
set statusline+=%{fugitive#statusline()} " Git Hotness
set statusline+=\ [%{&ff}/%Y]            " Filetype
set statusline+=\ [%{getcwd()}]          " Current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif
" end statusline }

" end basic }

" plugin mappings {

" fuzzy finders switch {
" set this var to switch fuzzy finder in use
" have used ctrlp for years and want to keep muscle memory through diff plugins

"let g:fuzzy_finder_plugin = "ctrp"
let g:fuzzy_finder_plugin = 'clap'


if g:fuzzy_finder_plugin ==# 'ctrlp'
" ctrlp {
    let g:ctrlp_switch_buffer = 'et'
    "  e - jump when <cr> is pressed, but only to windows in the current tab.
    "  t - jump when <c-t> is pressed, but only to windows in another tab.
    "  v - like "e", but jump when <c-v> is pressed.
    "  h - like "e", but jump when <c-x> is pressed.
    "  E, T, V, H - like "e", "t", "v", and "h", but jump to windows anywhere.
    "  0 or <empty> - disable this feature.

    let g:ctrlp_custom_ignore = {
      \ 'dir': '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$',
      \ 'file': '\v\.(exe|so|dll|pyc)$',
      \ }
    let g:ctrlp_cmd = 'CtrlPMRU'
    map <leader>pp :CtrlPMRU<CR>
    map <leader>pf :CtrlP<CR>
    map <leader>pb :CtrlPBuffer<CR>
    map <leader>pT :CtrlPTag<CR>
    map <leader>pt :CtrlPBufTag<CR>
    map <leader>pl :CtrlPLine<CR>
    map <leader>pu :CtrlPUndo<CR>
    map <leader>pc :CtrlPChangeAll<CR>

    " note: CtrlPMark requires plugin
    map <leader>pm :CtrlPMark<CR>
"   ctrlp end }

elseif g:fuzzy_finder_plugin ==# 'clap'
"   clap {

    " TODO get this to work? , 'ctrl-D': 'bdel'
    let g:clap_open_action={ 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit'}
"   ctrlp compat {
"   same missing different
"
    "same
    map <leader>pp :Clap history<CR>
    map <leader>pf :Clap files<CR>
    map <leader>pb :Clap buffers<CR>
    map <leader>pT :Clap proj_tags<CR>
    map <leader>pt :Clap tags<CR>
    map <leader>pm :Clap marks<CR>
    map <leader>pl :Clap blines<CR>
    map <leader>pL :Clap loclist<CR>

    " missing
    " map <leader>pu :Clap <CR> " TODO no undolist?
"    map <leader>pc :Clap <CR> " TODO no changelist?
"
"   ctrlp compat }
    " TODO several other related: bcommits,commits
    map <leader>pg :Clap git_diff_files <CR>
    map <leader>pG :Clap git_files <CR>
    map <leader>pj :Clap jumps<CR>
    map <leader>pq :Clap quickfix<CR>
    map <leader>pw :Clap windows<CR>
    map <leader>pr :Clap registers<CR>
    map <leader>pM :Clap maps<CR>
    map <leader>pP :Clap providers<CR>
    map <leader>pF :Clap filer<CR>
    map <leader>py :Clap yanks<CR>
    map <leader>ph :Clap help_tags <CR>
    map <leader>ps :Clap search_history<CR>
    map <leader>p :Clap <CR>
"
    " no pc but still leaving namespace for now
    map <leader>pC :Clap commits <CR>

" `:Clap quick_open` to open some dotfiles quickly.
let g:clap_provider_quick_open = {
      \ 'source': ['~/.config/nvim/init.vim', '~/.zshrc', '~/.tmux.conf'],
      \ 'sink': 'e',
      \ }
"   clap end }
endif

" fuzzy end }

" ale linting fixing {
" NOTE use :ALEINFO to make sure that you are using pylint from venv
let g:ale_linters = {
            \ 'zsh':['shellcheck']
            \ ,'sh':['shellcheck']
            \ ,'python':['pylint']
            \ ,'haskell':['stack_ghc']
            \ ,'typescript.tsx':['eslint']
            \}

let g:ale_linter_aliases = {'typescriptreact': 'typescript'}

let g:ale_sh_shellcheck_executable = 'shellcheck'
"let g:ale_python_pylint_executable = '~/.virtualenvs/py3nvim/bin/pylint'

let g:ale_fixers = {
            \ 'python':['isort', 'trim_whitespace', 'black'],
            \ 'rust':['rustfmt', 'trim_whitespace'],
            \ 'javascript':['prettier', 'trim_whitespace'],
            \ 'typescript':['prettier', 'trim_whitespace'],
            \ 'html':['prettier', 'trim_whitespace'],
            \ 'sh':['trim_whitespace'],
            \ 'vim':['trim_whitespace'],
            \}

let g:ale_fix_on_save = 1

nmap [w <Plug>(ale_previous_wrap_error) " ALEPrevious -wrap -error
nmap ]w <Plug>(ale_next_wrap_error) " ALENext -wrap -error

nmap [W <Plug>(ale_previous_wrap)
nmap ]W <Plug>(ale_next_wrap)
" TODO consider using ]W for only warnings and just use lnext for errors and warnings
" <Plug>(ale_next_wrap_warning) - ALENext -wrap -warning

" end ale }

" coc {
" https://github.com/neoclide/coc.nvim#example-vim-configuration
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"
" Use K to show documentation in preview window
" TOOD use preview window not coc hover
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"" Use <C-l> for trigger snippet expand.
"imap <C-l> <Plug>(coc-snippets-expand)

"" Use <C-j> for select text for visual placeholder of snippet.
"vmap <C-j> <Plug>(coc-snippets-select)

"" Use <C-j> for jump to next placeholder, it's default of coc.nvim
"let g:coc_snippet_next = '<c-j>'

"" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)


" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" end coc }

" nerdcommenter {
" black formatter making commenting not reversible
let g:NERDDefaultAlign = 'start'
"let g:NERDDefaultAlign = 'left'

" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
" end nerdcommenter }


" NerdTree {

let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '__pycache__']

let NERDTreeShowBookmarks=1
" never change cwd
let NERDTreeChDirMode=0

" Closes after opening a file. default is 0
let NERDTreeQuitOnOpen=1

" single click opens directory isnt of 2 clicks
let NERDTreeMouseMode=2

" show hidden files
let NERDTreeShowHidden=1

let g:nerdtree_tabs_open_on_gui_startup=0

nnoremap <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
nnoremap <leader>ee :NERDTreeFind<CR>
" end nerdtree }

" snippets {
set runtimepath+=~/.vim/UltiSnips
set runtimepath+=~/.config/nvim/UltiSnips
" TODO ultisnips is confused about .vim path vs .config/nvim path and was
" inserting .vim path as suffix which broke :UltiSnipsEdit
"let g:UltiSnipsSnippetDirectories=['~/.vim/UltiSnips/', '~/.vim/UltiSnips/javascript/', '~/.config/nvim/plugged/vim-snippets/UltiSnips']

" end snippets }

" tag related {
" choose tag plugin {
"let g:chosen_tag_prog = 'tagbar gutentags'
let g:chosen_tag_prog = 'vista'
if g:chosen_tag_prog ==# 'vista'
" chose vista {

" toggle vista
nnoremap  <leader>tt :Vista!!<CR>

" copied from ~/.config/nvim/plugged/vista.vim/autoload/vista/types/uctags/vim.vim
" then section line was added
let s:vista_custom_vim_types = {}
let s:vista_custom_vim_types.lang = 'vim'
let s:vista_custom_vim_types.kinds = {
    \ 'n': {'long' : 'vimball filenames',  'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',          'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'functions',          'fold' : 0, 'stl' : 1},
    \ 'a': {'long' : 'autocommand groups', 'fold' : 1, 'stl' : 1},
    \ 'c': {'long' : 'commands',           'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'maps',               'fold' : 1, 'stl' : 0},
    \ 's': {'long' : 'section',            'fold' : 0, 'stl' : 0}
    \ }
let g:vista#types#uctags#vim# = s:vista_custom_vim_types
" chose vista end }

elseif g:fuzzy_finder_plugin ==# 'tagbar gutentags'
"   chose tagbar gutentags {
" https://github.com/ludovicchabant/vim-gutentags/blob/master/doc/gutentags.txt
" https://github.com/majutsushi/tagbar/blob/master/doc/tagbar.txt

":TagbarOpenAutoClose opens the Tagbar window, jump to it and close it on tag selection. This is
"an alias for ":TagbarOpen fjc".
nnoremap  <leader>tt :TagbarOpenAutoClose<CR>
let g:gutentags_ctags_options_file='~/.ctags'
let g:gutentags_ctags_tagfile='.git/tags'
"let g:gutentags_ctags_tagfile="tags"
" copied from /home/kstock/.config/nvim/plugged/tagbar/autoload/tagbar/types/ctags.vim
" then added section!
" stl is for statusline
        "\ {'short' : 'n', 'long' : 'vimball filenames',  'fold' : 0, 'stl' : 1},
" {short}:{long}[:{fold}[:{stl}]]
let g:tagbar_type_vim     = {
            \'kinds' :[
                        \'s:sections:1:0',
                        \'n:vimballfilenames:0,1',
                        \'v:variables:1:0',
                        \'f:functions:0,1',
                        \'a:autocommandgroups:1,1',
                        \'c:commands:0,0',
                        \'m:maps:1,0',
    \]
    \,'kind2scope' : {
        \ 's' : 'section',
    \ }
    \,'sro' : '.'
    \}

let g:tagbar_type_typescript = {
                                  \ 'ctagsbin' : 'tstags',
                                  \ 'ctagsargs' : '-f-',
                                  \ 'kinds': [
                                    \ 'e:enums:0:1',
                                    \ 'f:function:0:1',
                                    \ 't:typealias:0:1',
                                    \ 'M:Module:0:1',
                                    \ 'I:import:0:1',
                                    \ 'i:interface:0:1',
                                    \ 'C:class:0:1',
                                    \ 'm:method:0:1',
                                    \ 'p:property:0:1',
                                    \ 'v:variable:0:1',
                                    \ 'c:const:0:1',
                                  \ ],
                                  \ 'sort' : 0
                                \ }
"
"
"
"   chose tagbar gutentags }
endif

" choose tag plugin end }

" end tag related }

" git related {

" git gutter {

" defaut is c for these
" but that conflicts with coc class textobj
" and does not match ,h mappings!
" nore form not does not work not sure why
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" dude doesn't want this in plugin for some reason!!
" How to make GitGutter{Prev,Next}Hunk to wrap around? #260
" https://github.com/airblade/vim-gitgutter/issues/260
function! GitGutterPrevHunkWrap(count)
  for i in range(1, a:count)
    let line = line('.')
    silent GitGutterPrevHunk
    if line('.') == line
      normal G
      silent GitGutterPrevHunk
      echo "wrapped"
    endif
  endfor
endfunction

function! GitGutterNextHunkWrap(count)
  for i in range(1, a:count)
    let line = line('.')
    silent GitGutterNextHunk
    if line('.') == line
      normal 1G
      silent GitGutterNextHunk
      echo "wrapped"
    endif
  endfor
endfunction

command! -count=1 GitGutterPrevHunkWrap call GitGutterPrevHunkWrap(<count>)
command! -count=1 GitGutterNextHunkWrap call GitGutterNextHunkWrap(<count>)

nmap [h :GitGutterPrevHunkWrap<cr>
nmap ]h :GitGutterNextHunkWrap<cr>
"nmap [h <Plug>(GitGutterPrevHunk)
"nmap ]h <Plug>(GitGutterNextHunk)

nnoremap <silent> <leader>Gq :GitGutterQuickFix<cr>:copen<cr>
" end git gutter }

" Fugitive {

" grepper uses ,g so these less common commands use ,G
" gitgutter uses ,Gq
nnoremap <silent> <leader>Gs :Gstatus<cr>
nnoremap <silent> <leader>Gl :Glog<cr>
nnoremap <silent> <leader>Gb :Gblame<cr>
nnoremap <silent> <leader>Gd :Gdiff<cr>
nnoremap <silent> <leader>Gc :Gcommit<cr>
"nnoremap <silent> <leader>Gp :git push<cr>

" end fugitive }

" git messenger {

"When this value is NOT set to "none", a popup window includes diff hunks of
"the commit at showing up. "current" includes diff hunks of only current file
"in the commit. "all" includes all diff hunks in the commit.
let g:git_messenger_include_diff='current'
let g:git_messenger_always_into_popup=v:true

function! s:setup_git_messenger_popup() abort
    " avoid having to press shift for O to go forward to new commit
    " though io seems kinda backwards...
    nmap <buffer>i O
endfunction

augroup git_messenger_setup_augroup
    autocmd!
    autocmd FileType gitmessengerpopup call s:setup_git_messenger_popup()
augroup END

" end git messenger}

" end git related }


" grepper {

command! Todo :Grepper -tool rg -noprompt -query 'TODO|FIXME'<CR>

" fugitive uses ,G
" because these more common commands are taking ,g namespace!
" however I'm keeping git-messenger gm since that is more common
nnoremap <leader>gb :Grepper -buffer<CR>
nnoremap <leader>gB :Grepper -buffers<CR>

nnoremap <leader>gg :Grepper -tool git<CR>
nnoremap <leader>gd :Grepper -tool rg<CR>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

"let g:grepper = {}            " initialize g:grepper with empty dictionary
runtime plugin/grepper.vim    " initialize g:grepper with default values

let g:grepper.tools = ['rg', 'ack', 'ag', 'ack-grep', 'grep', 'git', 'pt', 'sift']

" Make some shortands for various grep programs
" https://github.com/ViViDboarder/vim-settings/blob/e085795b92dd28e4a775d310ad887518663038aa/vim/rc/plugins/vim-grepper.rc.vim
if executable('rg')
    command! -nargs=+ Rg :GrepperRg <args>
endif
if executable('ag')
    command! -nargs=+ Ag :GrepperAg <args>
endif
if executable('ack')
    command! -nargs=+ Ack :GrepperAck <args>
endif


" end }

" jp {
" pacman -S skk-jisyo
"https://vi.stackexchange.com/questions/8733/can-i-write-japanese-skk-text-in-vim
let g:eskk#large_dictionary = {
\   'path': '/usr/share/skk/SKK-JISYO.L',
\   'sorted': 1,
\   'encoding': 'euc-jp',
\ }

nnoremap <leader>j :call eskk#toggle()<CR>

" <C-j> used for snippets!
let g:eskk#no_default_mappings = 1
imap <C-j><C-j> <Plug>(eskk:toggle)
" end }
" easy-align {
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" end easy-align }

" signature {
" solution to signature column being hard to see
" https://github.com/kshenoy/vim-signature/issues/116
hi SignColumn guibg=none
hi SignColumn ctermbg=none
hi SignatureMarkText ctermbg=none
" signature }

" macrobatics {
" TODO
" https://github.com/svermeulen/vim-macrobatics
" worried remap default will fuck up muscle memory when without config
" also breaks 'q:'
" Use <nowait> to override the default bindings which wait for another key press
nmap <nowait> <leader>q <plug>(Mac_Play)
nmap <nowait> <leader>gq <plug>(Mac_RecordNew)

nmap <leader>mh :DisplayMacroHistory<cr>

" [m is taken by method nav
nmap <leader>[m <plug>(Mac_RotateBack)
nmap <leader>]m <plug>(Mac_RotateForward)

nmap <leader>ma <plug>(Mac_Append)
nmap <leader>mp <plug>(Mac_Prepend)

nmap <leader>mng <plug>(Mac_NameCurrentMacro)
nmap <leader>mnf <plug>(Mac_NameCurrentMacroForFileType)
nmap <leader>mns <plug>(Mac_NameCurrentMacroForCurrentSession)

" requires fzf.vim or vim-clap, no ctrlp support as of 2020-07-30
nmap <leader>mo <plug>(Mac_SearchForNamedMacroAndOverwrite)
nmap <leader>mr <plug>(Mac_SearchForNamedMacroAndRename)
nmap <leader>md <plug>(Mac_SearchForNamedMacroAndDelete)
nmap <leader>me <plug>(Mac_SearchForNamedMacroAndPlay)
nmap <leader>ms <plug>(Mac_SearchForNamedMacroAndSelect)

" mc = macro copy
"then "x<leader>mc where x is the register you want to associate with the active macro.
nmap <leader>mc <plug>(Mac_CopyCurrentMacroToRegister)

" macrobatics }
"
" misc {

nnoremap <Leader>u :UndotreeToggle<CR>


" unimpaired makes [e do "exchange"
" this allows vertical visual selection moving
" analogous to >gv mapping
" TODO should these be like this??? wasn't working not sure on parens. noremap?
"nnoremap [E <Plug>(unimpairedMoveUp)gv
"nnoremap ]E <Plug>(unimpairedMoveSelectionDown)gv
vmap [E [egv
vmap ]E ]egv

" end misc }

" end plugin mappings }
