# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
# TODO
#           fasd belongs or use zinit?
#           filter langs: node go rust ruby haskell

# misc {
#
# vars {
TODAY=$(date "+%Y-%m-%d")
YESTERDAY=$(date --date="yesterday" +"%Y-%m-%d")
export TODAY
export YESTERDAY

# to get gephi to work in xmonad TODO needed?
#https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
export _JAVA_AWT_WM_NONREPARENTING=1
# vars }

export PATH=$PATH:$HOME/bin/

export MPD_HOST=localhost

# TODO his synclient should not be needed
#synclient TapButton1=1

# misc }

# fasd {
if [ -x "$(command -v fasd)" ];then
    eval "$(fasd --init auto)"
    alias o='f -e xdg-open'
    alias v='f -t -e vim -b viminfo'
    unalias z # from auto
    function z(){
        fasd_cd -d "$@"
        pwd
    }
else
    echo "no fasd!"
fi
# end fasd }


# js node {
# TODO add back if needed
#export NPM_MODULES=$HOME/bin/.node_modules/
#export NPM_MODULES_BIN=$NPM_MODULES/bin
#export NODE_PATH=$HOME/bin/.node_modules/lib/node_modules
#export NODE_BIN=$HOME/bin/.node_modules/bin
export NODE_BIN=$HOME/.node_modules/bin
export PATH=$PATH:$NODE_BIN

# Set up Node Version Manager
#source /usr/share/nvm/init-nvm.sh
#export NVM_DIR="$HOME/.nvm"                            # You can change this if you want.
#export NVM_SOURCE="/usr/share/nvm"                     # The AUR package installs it to here.
#[ -s "$NVM_SOURCE/nvm.sh" ] && . "$NVM_SOURCE/nvm.sh"  # Load NVM

# end node }

# ruby {
# TODO verify wanted
#export GEM_BIN=/home/kstock/.gem/ruby/2.3.0/bin
#export PATH=$PATH:$GEM_BIN
# ruby }


# go {
export PATH=$PATH:$HOME/go/bin
# go }

# rust {
export PATH=$PATH:$HOME/.cargo/bin
RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export RUST_SRC_PATH
# end rust }

# java {
export JAVA_HOME=/usr/lib/jvm/default
# end java }

# haskell {
export PATH=$PATH:/home/kstock/.cabal/bin
# end haskell }
