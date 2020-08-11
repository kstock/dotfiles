# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
# TODO
#       ordering
#       zinit wtf
#       fast-syntax-highlighting problem cases
#       fzf-tabs

# TODO need this sourced so history-search-multi-word can overwrite <C-r> mapping
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/zdharma/zinit
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# must be after compinit but before  fast-syntax-highlighting and autosuggestions
# TODO causes error
# uniq --uniq: extra operand ‘V:=__’
# https://github.com/Aloxaf/fzf-tab
#zinit light Aloxaf/fzf-tab

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

export FORGIT_NO_ALIASES=1
zinit wait lucid for \
    RobSis/zsh-completion-generator \
    wfxr/forgit \
    olivierverdier/zsh-git-prompt \

zinit light-mode for \
    zdharma/history-search-multi-word \

### End of Zinit's installer chunk
