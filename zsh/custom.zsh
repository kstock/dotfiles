# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
# TODO docs

# saved local results stuff{
# these all you to do "command tlr"
# and have the result cached in the file $RES
# $RES is escaped bc otherwise would be expanded when defined not when used, so can alter RES other places
export RES='/tmp/locres.txt'
export PLRES='/tmp/playlists.m3u'

alias -g tlr=' > $RES'
alias -g tlra=' >> $RES' #append
alias -g tlrcat=' > $RES && cat $RES'

alias cr='cat $RES'
alias eres='$EDITOR $RES'
# end saved local results stuff}

# boilerplates {
export BOILERPLATE_DIR=~/workspace/boilerplates
export TEMPLATE_DOCKERFILES="$BOILERPLATE_DIR/dockerfiles"

alias fromboilerplate="cp ~/workspace/boilerplates/"
alias toboilerplate="cp ~/workspace/boilerplates/"

alias boilerplate_cd="cd ~/workspace/boilerplates/"
alias boilerplate_ls="ls ~/workspace/boilerplates/"
alias boilerplate_tree="tree ~/workspace/boilerplates/"

# end boilerplates }

# learn random things{
function randman() {
# open a random man page
    pg=$(ls /usr/bin | shuf | head -1)
    echo "man " $pg
    man $pg
    }
# learn random things}

# redis {
function redis_set_file(){
    # dump entire file into redis key
    sh -x
    redis-cli -x set "$1" < "$2"
}
# end redis }

# misc {
#
export MY_TEMP=~/temp
alias cdtmp='cd $MY_TEMP'

# end misc }
