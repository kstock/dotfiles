" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
" }
"

" plug begin {
call plug#begin('~/.config/nvim/plugged')

    " TODO cf dirvish
    Plug 'scrooloose/nerdtree'
    " TODO investigate
    Plug 'Xuyuanp/nerdtree-git-plugin'

    Plug 'w0rp/ale'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'altercation/vim-colors-solarized'

    Plug 'tpope/vim-projectionist'
    Plug 'tpope/vim-unimpaired'

    " cf fzf.vim
    Plug 'kien/ctrlp.vim'
    " TODO
    "Plug 'ivan-cukic/vim-ctrlp-switcher'
    Plug 'mattn/ctrlp-mark'

    Plug 'scrooloose/nerdcommenter'


    Plug 'machakann/vim-sandwich'
    Plug 'tpope/vim-obsession'

    " git related
    Plug 'airblade/vim-gitgutter'
    Plug 'rhysd/git-messenger.vim'
    Plug 'tpope/vim-fugitive'
    " following 2 needed to make symlinks work in fugitive
    Plug 'moll/vim-bbye' " optional dependency for symlink
    Plug 'aymericbeaumet/vim-symlink'

    Plug 'cespare/vim-toml'

    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    Plug 'kshenoy/vim-signature'

    Plug 'tpope/vim-eunuch'

    " cf for lsp support https://github.com/liuchengxu/vista.vim
    Plug 'majutsushi/tagbar'

"    Plug 'ryanoasis/vim-devicons'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'

    Plug 'mattn/emmet-vim'

    Plug 'mhinz/vim-grepper'

    Plug 'janko/vim-test'

    Plug 'ludovicchabant/vim-gutentags'

    " cf vim-mundo
    Plug 'mbbill/undotree'

    Plug 'tyru/eskk.vim'

    Plug 'tpope/vim-abolish'

    " cf repmo and see if ;, suffice
    "use space to repeat motions!
    "Plug 'spiiph/vim-space'

call plug#end()
" end plug }

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
" }
" settings {
"
let mapleader = ','
" leader currently used up , (repeat motion backwards)
" keeping this mapping here instead of in mapping section for simplicity
nnoremap <silent> <Leader>; ,

set clipboard=unnamedplus

" show existing tab with 4 spaces width
set tabstop=4
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

set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic  whitespace KYLE, colors were messed up in python
"set listchars=trail:.",extends:#,nbsp:. " Highlight problematic  whitespace KYLE, colors were messed up in python

set tags^=./.git/tags;

set dictionary=/usr/share/dict/usa

colorscheme solarized

" default is 4000. in particular is nice for gitgutter
set updatetime=100

"let g:solarized_termcolors=256
let g:solarized_termcolors=16


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


" easy save
map <leader>w :w<CR>
map <leader>W :wa<CR>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

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
augroup END

" Always switch to the current file directory
" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" claim is autochdir can not play well with plugins
augroup setcwd
    autocmd!
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
augroup END

"https://vi.stackexchange.com/questions/18177/how-to-force-redraw-when-returning-to-command-line-from-command-line-history-win?rq=1
augroup my_cmdline_window
    autocmd!
    autocmd CmdWinEnter * nno  <buffer><expr><nowait>  <c-c>  '<c-c>'.timer_start(0, {-> execute('redraw')})[-1]
augroup END

augroup foldmethods
    autocmd!
    autocmd BufNewFile,BufRead *.py set foldmethod=indent
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

" ctrlp {
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
map <leader>pm :CtrlPMark<CR>
map <leader>pl :CtrlPLine<CR>
map <leader>pu :CtrlPUndo<CR>
map <leader>pc :CtrlPChangeAll<CR>
" }

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
"let g:NERDDefaultAlign = 'start'
let g:NERDDefaultAlign = 'left'

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
" }
"

" nerdtree {
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
"
"Open the Tagbar window, jump to it and close it on tag selection. This is
"an alias for ":TagbarOpen fjc".
nnoremap  <leader>tt :TagbarOpenAutoClose<CR>

let g:gutentags_ctags_options_file='~/.ctags'
let g:gutentags_ctags_tagfile='.git/tags'
"let g:gutentags_ctags_tagfile="tags"
"
"
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

nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)

" end git gutter }

" Fugitive {

" grepper uses ,g so these less common commands use ,G
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


" misc {

nnoremap <Leader>u :UndotreeToggle<CR>

" end misc {

" end plugin mappings }
