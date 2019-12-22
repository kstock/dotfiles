" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
" }

" plug begin {
call plug#begin('~/.config/nvim/plugged')


    " NerdTree {
    "
        " TODO cf dirvish
        Plug 'scrooloose/nerdtree'
        " TODO investigate
        Plug 'Xuyuanp/nerdtree-git-plugin'

        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']

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
    " ale linting fixing {
    Plug 'w0rp/ale'
    " NOTE use :ALEINFO to make sure that you are using pylint from venv
    let g:ale_linters = {
                \ 'zsh':['shellcheck']
                \ ,'sh':['shellcheck']
                \ ,'python':['pylint']
                \ ,'typescript.tsx':['eslint']
                \}
    let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
    let g:ale_sh_shellcheck_executable = 'shellcheck'
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
    " }

    " Use release branch
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'altercation/vim-colors-solarized'
    "let g:solarized_termcolors=256
    let g:solarized_termcolors=16

    " 2018-11-30
    :cnoremap <C-A> <Home>
    :cnoremap err lopen<CR>

    Plug 'tpope/vim-projectionist'

    Plug 'janko/vim-test'

    Plug 'tpope/vim-unimpaired'

    Plug 'kien/ctrlp.vim'
    " TODO
    "Plug 'ivan-cukic/vim-ctrlp-switcher'
    Plug 'mattn/ctrlp-mark'

    Plug 'scrooloose/nerdcommenter'

    Plug 'airblade/vim-gitgutter'
    Plug 'rhysd/git-messenger.vim'

    Plug 'machakann/vim-sandwich'
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-fugitive'

    Plug 'cespare/vim-toml'

    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    Plug 'kshenoy/vim-signature'

    Plug 'tpope/vim-eunuch'
    Plug 'majutsushi/tagbar'

"    Plug 'ryanoasis/vim-devicons'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'

    Plug 'mattn/emmet-vim'
    Plug 'mhinz/vim-grepper'

    Plug 'ludovicchabant/vim-gutentags'
call plug#end()
" }

colorscheme solarized


" Stupid shift key fixes
    if has("user_commands")
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

cmap Tabe tabe
let mapleader = ','
inoremap jj <Esc>


set nu                          " Line numbers on
set rnu                         " relative line numbers
" absolu-te line numbers in insert mode, relative otherwise for easy movement
au InsertEnter * :set rnu!
au InsertLeave * :set rnu


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


map <leader>w :w<CR>



" Mimic Emacs Line Editing in Insert Mode Only
inoremap <C-A> <Home>
inoremap <C-E> <End>

inoremap <C-K> <Esc>lDa
inoremap <C-U> <Esc>d0xi


" Toggle search highlighting
nmap <silent> <leader>/ :set invhlsearch<CR>


" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" The following two lines conflict with moving to top and
" bottom of the screen
map <S-H> gT
map <S-L> gt

set clipboard=unnamedplus

let g:NERDDefaultAlign = 'start'

nnoremap  <leader>tt :TagbarOpenAutoClose<CR>

nnoremap <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
nnoremap <leader>ee :NERDTreeFind<CR>


set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic  whitespace KYLE, colors were messed up in python
"set listchars=trail:.",extends:#,nbsp:. " Highlight problematic  whitespace KYLE, colors were messed up in python

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Always switch to the current file directory
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif



set rtp+=~/.vim/UltiSnips
set rtp+=~/.config/nvim/UltiSnips
let g:UltiSnipsSnippetDirectories=["~/.vim/UltiSnips/", "~/.vim/UltiSnips/javascript/", "~/.config/nvim/plugged/vim-snippets/UltiSnips"]

set tags^=./.git/tags;
"set tags=./.git/tags;

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%


"" Use <C-l> for trigger snippet expand.
"imap <C-l> <Plug>(coc-snippets-expand)

"" Use <C-j> for select text for visual placeholder of snippet.
"vmap <C-j> <Plug>(coc-snippets-select)

"" Use <C-j> for jump to next placeholder, it's default of coc.nvim
"let g:coc_snippet_next = '<c-j>'

"" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
"let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

set ignorecase
set smartcase

nnoremap Y y$

let g:gutentags_ctags_options_file="~/.ctags"
let g:gutentags_ctags_tagfile=".git/tags"
"let g:gutentags_ctags_tagfile="tags"
"
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
