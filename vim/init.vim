call plug#begin('~/.config/nvim/plugged')


    " NerdTree {
    "
        " TODO cf dirvish
        Plug 'scrooloose/nerdtree'
        " TODO investigate
        Plug 'Xuyuanp/nerdtree-git-plugin'

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }
    "

    " Use release branch
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'altercation/vim-colors-solarized'
    "let g:solarized_termcolors=256
    let g:solarized_termcolors=16


    Plug 'w0rp/ale'
    " NOTE use :ALEINFO to make sure that you are using pylint from venv
    let g:ale_linters = {
                \ 'zsh':['shellcheck']
                \ ,'sh':['shellcheck']
                \ ,'python':['pylint'] 
                \}
    let g:ale_sh_shellcheck_executable = 'shellcheck'
    let g:ale_fixers = {
                \ 'python':['isort', 'trim_whitespace', 'black'],
                \ 'rust':['rustfmt', 'trim_whitespace'],
                \ 'javascript':['prettier', 'trim_whitespace'],
                \ 'html':['prettier', 'trim_whitespace']
                \}

    let g:ale_fix_on_save = 1

    nmap [w <Plug>(ale_previous_wrap_error) " ALEPrevious -wrap -error
    nmap ]w <Plug>(ale_next_wrap_error) " ALENext -wrap -error

    nmap [W <Plug>(ale_previous_wrap)
    nmap ]W <Plug>(ale_next_wrap)

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

call plug#end()

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
"}
"
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
let g:UltiSnipsSnippetDirectories=["~/.vim/UltiSnips", "~/.config/nvim/plugged/vim-snippets/UltiSnips"]

set tags^=./.git/tags;

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
