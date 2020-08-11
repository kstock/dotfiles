# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# random zsh functions
# myutils has some explainations
# }


man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

function cdl {
    cd "$@" && ls -lahtr
}

export YMDHH="%Y-%m-%d %H:%M"
function get_now(){
    NOW=$(date +"$YMDHH")
    echo "$NOW"
}

psaux (){
        ps aux | grep "$1" | grep -v "grep $1"
}
# mkdir then do X {

mkcd(){
    mkdir -p "$1" ; cd "$1"
}

mkmv(){
    mv "$1" "$2"
    cd "$2"
}

# }

# find wrappers{
fin(){
    local grep_prog="${CHOSEN_GREP_PROG:-grep}"
    set -x
    find . -iname "*$1*" | "$grep_prog" -v '(target/|.venv|/\.)'
}
# find wrappers}

# spelling stuff{

spel(){
    # spellcheck a word
    #$ spel imiture
    #@(#) International Ispell Version 3.1.20 (but really Aspell 0.60.7-20110707)
    #& imiture 10 0: immature, imitate, immure, mature, impure, armature, immured, maturer, impurer, emitter
    echo "$1" | aspell -a
}

function alfsort(){
    #print order of letters
    echo "$1" | grep -o . | sort -u | tr -d '\n'
    #echo "$1" | awk -v FS="" '{for (i=1;i<=NF;i++){print $i}}' | sort -u | awk '{printf($0)}'
}


function lord(){
    #Letter ORDer, print the ascii chars offset before and after a letter
    #lord h 6 -> bcdefg_H_ijklm
    offset=${2:-3}
    #echo "$1"
    python -c 'c="'$1'";offset='$offset';i = ord(c);ans= "".join( chr(x) for x in range(i -offset,i + offset));print ans.replace(c,"_"+c.upper() + "_")'
}

# spelling stuff}
#
# https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding
function urlencode(){
    #python -c "import sys, urllib as ul; print( ul.quote_plus(\"$1\"))"
    #python -c "import sys, urllib as ul; print( ul.quote(\"$1\"))"
    # TODO
    perl -pe 's/ /%20/g'
}
function urldecode(){
    #python -c "import sys, urllib as ul; print( ul.unquote_plus(\"$1\"))"
    python -c "import sys, urllib as ul; print( ul.unquote(\"$1\"))"
}

function httpless() {
    # `httpless example.org'
    http --pretty=all --print=hb "$@" | less -R;
}


function wifisignal(){
    watch -n 1 "awk 'NR==3 {print \"WiFi Signal Strength = \" \$3 \"00 %\"}''' /proc/net/wireless"
}


rcd() {
    #open ranger , cd to last dir was in while using
       #tempfile=$(mktemp)
       tempfile=/tmp/rcd
       echo '' > $tempfile
       ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
       test -f "$tempfile" &&
       if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
         cd -- "$(cat "$tempfile")"
         pwd
       fi
       #trash -f -- "$tempfile"
 }



npmigc () {
    if [ "$#" = 0 ];then
        echo "usage: npmigc lib1 [lib2 lib3 ..]"
        return 1
    fi

    GROOT="$(git rev-parse --show-toplevel)"
    if [[ -z "$GROOT" ]];then
        echo "not a git repo quiting"
        return 1
    fi

    npm install $@

    git add "$GROOT/package-lock.json" "$GROOT/package.json"
    git status -uno

    MSG="chore(dep):$@"
    echo "$MSG"
    git commit -m "$MSG"
}
function checkempty(){ # TODO use as helper?
    if [[ -z "$1" ]];then
        echo "$2"
        return 1
    fi
    return 0
}


function dosound(){
    DIR="$HOME"
    FILE="$DIR/chime_up.wav"
    aplay -q "$FILE" > /dev/null 2>&1
}

function play_in_s(){
    sleep $1
    dosound
}
function play_in_m(){
    date
    TIME=$(( $1 * 60 ))
    sleep $TIME
    dosound
    date
}
function lpdf(){
    # external dep: pdflatex
    pdflatex -output-directory output "$1"
    FNAME=$(echo "$1" | perl -pe 's/tex/pdf/')
    mv "./output/$FNAME" .
}
cdf() {
   # cdf - cd into the directory of the selected file
   local file
   local dir
   file="$1" && dir=$(dirname "$file") && cd "$dir"
}

stripansi(){
    # https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream
    perl -pe '
      s/\e\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]//g;
      s/\e[PX^_].*?\e\\//g;
      s/\e\][^\a]*(?:\a|\e\\)//g;
      s/\e[\[\]A-Z\\^_@]//g;'
}
alias -g SA=' | stripansi'

# stupid gimmicks {
function is_prime(){
# filter to just prime numbers
#
# $ seq 5 | is_prime
# 2 is prime
# 3 is prime
# 5 is prime
    perl -lne '(1x$_) !~ /^1?$|^(11+?)\1+$/ && print "$_ is prime"' $1
}

# draw mandelbrot set
function most_useless_use_of_zsh {
   local lines columns colour a b p q i pnew
   ((columns=COLUMNS-1, lines=LINES-1, colour=0))
   for ((b=-1.5; b<=1.5; b+=3.0/lines)) do
       for ((a=-2.0; a<=1; a+=3.0/columns)) do
           for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)) do
               ((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
           done
           ((colour=(i/4)%8))
            echo -n "\\e[4${colour}m "
        done
        echo
    done
}

# stupid gimmicks }
