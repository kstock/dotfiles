# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }

# TODO has gather
# choices {

# grep {
CHOSEN_GREP_PROG="grep"
CHOSEN_GREP_NOCOLOR=" --color=never"
if command -v rg >/dev/null ;then
    CHOSEN_GREP_PROG="rg"
elif command -v ack >/dev/null ;then
    CHOSEN_GREP_PROG="ack"
    CHOSEN_GREP_NOCOLOR=" --no-color"
fi
export CHOSEN_GREP_PROG
# end grep }

# aur {

CHOSEN_AUR_PROG="missing_aur_helper"

if command -v yay >/dev/null ;then
    CHOSEN_AUR_PROG="yay"
elif command -v aura >/dev/null ;then
    CHOSEN_AUR_PROG="aura"
elif command -v yaourt >/dev/null ;then
    CHOSEN_AUR_PROG="yaourt"
fi
export CHOSEN_AUR_PROG
# end aur }

# end choices }


# shell utility wrappersbuiltin-wrappers {

# misc {
alias j=jobs
alias c=clear

alias duh='du -lh'
alias dfh='df -lh'

alias bci='bc -l <<<' # bc interactive, bci '1+1' ->  2
# TODO dangerous assumting for muscle memory
alias cp='nocorrect cp -i '

alias cdr='cd $(ls -r | head -1)' #cd to most recent directory

alias fullpath="readlink -f "
alias highcpu='ps -eo pcpu,pid,user,args | sort -k1 -r -n | head -10'
alias myip='ip addr | grep 192'

# end misc }
#
# ls{
alias ls="ls --color=auto"
alias l="ls -lh --time-style long-iso"
alias sl="ls "
alias lsd="ls -d ./*/" # ls directories
alias lstd="ls *(m0)" # ls things from today
# ls}

# mv{
#
alias mv="nocorrect mv -i"

# https://www.nongnu.org/renameutils/
alias qmv='qmv -f dc -o swap' #dest column first, then old name
# mv}
#
# tree {
# sudo pacman -S extra/tree
export _TREE_IGNORE="-I node_modules"
alias treed1='tree $_TREE_IGNORE -d -L 1'
alias treed2='tree $_TREE_IGNORE -d -L 2'
alias treed3='tree $_TREE_IGNORE -d -L 3'
treedn(){
    # treed1 . == treedn 1 .
    tree "$_TREE_IGNORE" -d -L "$1" "$2"
}
# end tree}

# package manager {

# pacman {
alias pac='pacman '
alias pacs='pacman -Ss '
alias pacS='sudo pacman -S '

alias pacr='pacman -Rs'   # Remove. s means include dependent packages too

alias pacc='pacman -Scc'    # clean cache
alias paclf='pacman -Ql'   # list files

alias paclo='pacman -Qdt'    # list orphans
alias pacQs='pacman -Qs '
alias pacQi='pacman -Qi '

alias paci='pacman -Si'      # info

alias pacro='paclo && sudo pacman -Rns $(pacman -Qtdq)' # remove orphans

# forget these so basically doc via tab completion
alias pacman_list_files_owned='pacman -Qlq'
# u to update. e for explicitly installed
alias pacman_list_need_upgrade='pacman -Que'
alias pacman_delete_cache_till_3='paccache -r'

alias paclogs='cat /var/log/pacman.log '
alias pacman_cd_cache='cd /var/cache/pacman/pkg'

# end pacman }

# aur {
alias yacs='$CHOSEN_AUR_PROG -Ss '
alias yacS='$CHOSEN_AUR_PROG -S  '

# end aur }
#
# end package manager }

# gloabl aliases {

# misc {

# grep Aopt '-E'
alias -g AOPT=' --help | $CHOSEN_GREP_PROG -A 2 -- '   # easy grep option meanings
alias -g FZ=" | fzf "

# adds timestamp
alias -g TS=' | while read line ; do echo "$(date)| $line"; done;'

# externl dep: csvkit https://csvkit.readthedocs.io/
alias -g 2TS=' | csvformat -T'
alias -g COL=' | csvcut -t -c '

alias -g FULLPATHS=" | xargs -d'\n' readlink -f "
alias -g ALIGN=" | column -s $'\t' -t "

# external dep: https://stedolan.github.io/jq/
alias -g JQ="| jq '.'"
alias -g JQC="| jq -C '.'"
alias -g JQL="| jq -C '.' | less -R "

alias -g AWKT=" | awk -F'\t'  "

alias -g C='| wc -l'
alias -g H='| head'
alias -g T='| tail'

alias -g L="| less -R"
alias -g LS='| less -S'

alias -g PE=' | perl -pe '
# comma to newline
alias -g SNL="| sed -e 's/,/\n/g'"

alias -g TL="tree -C | less "
alias -g Te="| tee -a "

# -R is readonly for viewing in vim in middle of pipeline
alias -g V='| col -b | vim -R -'

alias -g VER=' --version'

alias -g X="| xargs -d'\n'"
alias -g Xl="| xargs -I {} -d'\n' "

# external dep: xlcip, fzf
alias -g XC='| xclip -selection clipboard'
alias -g XCF='| fzf | xclip -selection clipboard'
# end misc }
#
# navigation{
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
# }
# searching{
# TODO fall back on grep? check args
#
alias -g G="| grep"
alias -g Gi="| grep -i "
alias -g Gv="| grep -v "
alias -g Gnc="| grep --color=never "

alias -g A='| $CHOSEN_GREP_PROG '
# case Insensitive
alias -g Ai='| $CHOSEN_GREP_PROG -i '
# inVert match
alias -g Av='| $CHOSEN_GREP_PROG -v '
# ensure No Color
alias -g Anc='| $CHOSEN_GREP_PROG $CHOSEN_GREP_NOCOLOR '

alias 'h?'='fc -li 0 | $CHOSEN_GREP_PROG '
# searching}

# sort/unique{
alias -g S=' | sort '
alias -g NS=' | sort -n '
alias -g RNS=' | sort -nr '
alias -g SH=' | sort -h'
alias -g RSH=' | sort -hr'
alias -g U=' | uniq '
alias -g US=' | sort -u '
alias -g SU=' | sort -u '

alias -g CNT=' | sort  | uniq -c  | sort -n '
# sort/unique}

#extension shorthands{
#convenient for listing all files in dir of media type
alias -g IM='*.(jpg|png|gif|jpeg|webm)'
alias -g TXT='*.(pdf|txt|tex|rtf)'
alias -g MOV='*.(avi|wmv|mkv|mp4|flv)'
alias -g EAR='*.(mp3|ogg|flac|m4a)'
alias -g COM='*.(cbr|cbz)'
alias -g RAR='*.(tar|gz|zip|rar|7z)'
#extension shorthands}

# end gloabl aliases }

# TODO external commands {
alias ccat='pygmentize '
alias catp='pygmentize '
alias ccatn3='pygmentize -P encoding=latin1 -l n3 '

alias za='zathura '
alias mc='mcomix'
alias 'scn'="scanimage -v --resolution=300 --device 'pixma:04A91731_E02B81' --format=png "
# TODO external commands }
