# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
# # TODO:
#        setopt
#        bindkey
#        ackrc-like
#        zstyle
#        ZSH_DOT_DEBUG
#        bashsourcing
#        listfunctions wtf
#        check_and_log_err
#        has
#        _kexpand
#
#zmodload zsh/zprof

# meta {
# env {

export EDITOR=nvim # most important line

export ZSH_DOTFILES_HOME="$HOME/revised_dotfiles/zsh"
export VIMSESSION_DOTFILES=$ZSH_DOTFILES_HOME/Session.vim # DEPENDS CREATE FILE

# TODO idea is zshrc append to this file on errors
export ZSH_DOT_DEBUG=/tmp/zshrc_dot_debug.txt
echo -n '' > $ZSH_DOT_DEBUG
# env }

# dotfile editing related {
ZSH_DOTFILE_SYMLINK_PATH="$(ls -l ~/.zshrc | grep -o '.home.*')"
# expands out to show symlink source:
# ~/.zshrc && echo 'ZSH config reloaded from /home/kstock/.zshrc -> /home/kstock/dotfiles/kenvy/zsh/zshrc_kenvy'
alias reload=". ~/.zshrc && echo 'ZSH config reloaded from $ZSH_DOTFILE_SYMLINK_PATH'"
alias rel="reload"

# Edit RC files
alias erc='$EDITOR -S $VIMSESSION_DOTFILES'
alias ercs='$EDITOR -S $VIMSESSION_DOTFILES ; reload'

alias dotvims='ls -lh --time-style long-iso -a ~/ | grep vim'
alias dota='ls -lh --time-style long-iso -a ~/ | grep '

# end dotfile related }

# dotfile debugging related {

export SOURCE_DUMP=/tmp/bashsourcing
alias catsource='cat $SOURCE_DUMP '
function sourcedump(){
    set -x
    zsh -x ~/.zshrc  &> /tmp/bashsourcing
}

# https://superuser.com/questions/681575/any-way-to-get-list-of-functions-defined-in-zsh-like-alias-command-for-aliases
alias listfunctions='echo  ${(ok)functions} | tr " " "\n" '

function ackrc(){
    # search aliases, functions, and dotfiles themselves
    # TODO CHOSEN_GREP_PROG, rg
    local QUERY="$1"

    listfunctions | ack "$QUERY"
    alias | ack "$QUERY"
    ack "$QUERY" $ZSH_DOTFILES_HOME
    #ack "$QUERY""$VIMWIKI_HOME/myman"
}

check_and_log_err() {
    cmd="$1"
    errmsg="$2"

    if ! [ -x "$(command -v "$cmd")" ]; then
      echo "Error: $cmd is not installed. $errmsg" >> "$ZSH_DOT_DEBUG"
      return 0
    fi
    return 1

}

announce_errs(){
    if [ -s $ZSH_DOT_DEBUG ]; then
       echo "errors! check $ZSH_DOT_DEBUG"
    fi
}

# dotfile debugging related }

# vims session {
# TODO unfiy?
function vims(){
    local SESSION_FILE
    SESSION_FILE="${1:-Session.vim}"
    [[ $SESSION_FILE == *.vim ]] || SESSION_FILE+=.vim # make sure has .vim suffix
    [ -f "$SESSION_FILE" ] && vim -S "$SESSION_FILE" || vim -c ":Obsession $SESSION_FILE"
}

function nvims(){
    local SESSION_FILE
    SESSION_FILE="${1:-Session.vim}"
    [[ $SESSION_FILE == *.vim ]] || SESSION_FILE+=.vim # make sure has .vim suffix
    [ -f "$SESSION_FILE" ] && nvim -S "$SESSION_FILE" || nvim -c ":Obsession $SESSION_FILE"
}
alias vims_refresh="rm -f Session.vim && vim -c ':Obsession'"
alias nvims_refresh="rm -f Session.vim && nvim -c ':Obsession'"

cat_session(){
    local SESSION_FILENAME=${1-Session.vim}
    if [ ! -f "$SESSION_FILENAME" ]; then
        echo "$SESSION_FILENAME does not exist"
        return
    fi

    wc -l "$SESSION_FILENAME"

    stat "$SESSION_FILENAME" | grep -E 'Modify|Birth' | sed 's/\..*//' | tr '\n' '|'
    echo # so next line is not on same line!!!

    NUM_BUFFERS="$(grep badd $SESSION_FILENAME | wc -l)"
    echo "num buffers: $NUM_BUFFERS"

    DIR=${PWD/#$HOME/''}
    grep badd "$SESSION_FILENAME"\
        | sed "s;.*$DIR;.;" | sed 's/badd +[0-9]\+//'\
        | sort | nl
}
# vims session }

# meta }

# options {
#
# http://zsh.sourceforge.net/Doc/Release/Options-Index.html

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc. (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB

#If numeric filenames are matched by a filename generation pattern, sort the filenames numerically rather than lexicographically.
setopt numeric_glob_sort

# cursor is moved to the end of the word if either a single match is inserted or menu completion is performed
setopt alwaystoend

# cd without typing cd if command is a directory in cwd
setopt autocd

setopt cdablevars

##TODO dirstack
#setopt autopushd
#
#setopt completeinword
#setopt extendedglob
#setopt extendedhistory
#setopt noflowcontrol
#setopt histexpiredupsfirst
#setopt histignoredups
#setopt histignorespace
#setopt histnostore
#setopt histverify
#setopt incappendhistory
#setopt interactive
#setopt kshglob
#setopt login
#setopt longlistjobs
#setopt monitor
#setopt numericglobsort
#setopt promptsubst
#setopt pushdignoredups
#setopt pushdminus
#setopt sharehistory
#setopt shinstdin
#setopt zle
# options }

# keybindings {

# history navigation {
# TODO
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward

#bash muscle memory
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

bindkey -M viins "^p" history-beginning-search-backward
bindkey -M viins "^n" history-beginning-search-forward

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# # Search based on what you typed in already
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

# history navigation }

# misc {
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M vicmd 'u' undo
#
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#go back in autocomplete with shift tab
bindkey '^[[Z' reverse-menu-complete
# misc }

# emacs in insert  {

bindkey -M viins "^a" beginning-of-line
bindkey -M vicmd "^a" beginning-of-line

bindkey -M viins "^e" end-of-line
bindkey -M vicmd "^e" end-of-line

bindkey -M viins "^k" kill-line
bindkey -M vicmd "^k" kill-line

bindkey -M viins "^w" backward-kill-word
bindkey -M vicmd "^w" backward-kill-word
# emacs in insert  }

# custom {

_kexpand(){  # TODO
#expand alias and where functions
#https://unix.stackexchange.com/questions/289883/binding-key-shortcuts-to-shell-functions-in-zsh
#https://sgeb.io/posts/2014/04/zsh-zle-custom-widgets/#which-widget-is-invoked-by-a-given-shortcut
    zle _expand_alias
    if [[ "$?" != 0 ]];then
        echo "\n$(where $BUFFER)\n"
    fi
}
zle -N _kexpand
#bindkey '^g' _expand_alias
bindkey '^g' _kexpand


# https://unix.stackexchange.com/questions/290125/copying-current-command-line-to-clipboard
copy-to-xclip() {
    zle kill-buffer
    print -rn -- "$CUTBUFFER" | xclip -selection clipboard
    print -rn -- "$CUTBUFFER"
}; zle -N copy-to-xclip
bindkey -M viins "^]" copy-to-xclip
# custom }

# keybindings }

# this is not handled by zinit in revised_bundles.zsh
# compinit {
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html
#autoload -Uz compinit

# #only regen once a day
# #https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
#for dump in ~/.zcompdump(N.mh+24); do
#  echo "again"
#  compinit
#done

#compinit -C

# end compinit }

# announce_errs # TODO

#"dircolors.256dark"


# zstyle {
# # TODO https://github.com/Aloxaf/fzf-tab/
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*' menu select=2
zstyle ":completion:*:descriptions" format "%B%d%b"

#zstyle ':completion:*:approximate:*' max-errors 2
# or to have a better heuristic, by allowing one error per 3 character typed
zstyle ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# end zstyle }

# source subfiles {
declare -a filelist=(
    "bundles.zsh"

    "env.zsh"
    "history.zsh"

    "aliases.zsh"
    "functions.zsh"

    "docker.zsh"
    "git.zsh"
    "tmux.zsh"
    "systemd.zsh"
    "fuzzy.zsh"
    "python.zsh"

    "custom.zsh"
    "temper.zsh"

    "sensitive.zsh"

    "themes/kyle.theme.zsh"
 )

for dotfile in ${filelist[@]}
do
    if [[ -f "$ZSH_DOTFILES_HOME/$dotfile" ]]; then
        source "$ZSH_DOTFILES_HOME/$dotfile"
    else
        echo "missing dotfile $dotfile"
    fi
done

# end source subfiles }
#
#zprof
