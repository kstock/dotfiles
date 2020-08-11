# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
# https://github.com/junegunn/fzf/wiki/examples
# in revised_git.zsh
#fbr
#TODO full filter
# cd helpers {

fd1() {
    # select dir depth 0 in tmux pane
  DIR=`find * -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` \
    && cd "$DIR" && pwd
}

cdfz() {
    # cd into the directory of the selected file
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}


lcdf() {
# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
  local file

  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
     pwd
  fi
}

fj() {
# fj - fast jump. changing directory with fasd
  local dir
  # -Rdl revese directory list without ranks
  # +m is no multiselect
  dir=$(fasd -Rdl | fzf --no-sort +m) && cd "$dir"
}

fup() {
    # cd upto selected parent directory
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}
# end cd helpers}


# file opens {
#
vg() {
  local file
  local line

  read -r file line <<<"$(ack --nocolor --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     $EDITOR $file +$line
  fi
}
ftags() {
    # ftags - search ctags with preview
    # only works if tags-file was generated with --excmd=number
    # TODO DEPENDS bat
  local line
  local TAGFILE
  local gitroot

  gitroot="$(git rev-parse --show-toplevel)"
  TAGFILE="$gitroot/.git/tags"

  [ -e "$TAGFILE" ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' "$TAGFILE" |
    fzf \
      --nth=1,2 \
      --with-nth=2 \
      --preview-window="50%" \
      --preview="bat {3} --color=always | tail -n +\$(echo {4} | tr -d \";\\\"\")"
  ) && ${EDITOR:-vim} $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}
# end file opens }



# misc {
fh() {
    # history search
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# https://wiki.archlinux.org/index.php/Fzf#Pacman
# TODO
pacfzf(){
    pacman -Slq | fzf --multi --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk "{print \$2}")' | xargs -ro sudo pacman -S
}

TODOfbfzf() {
    # save newline separated string into an array
    # external dep buku
    mapfile -t website <<< "$(buku -p -f 5 | column -ts$'\t' | fzf --multi)"

    # open each website
    for i in "${website[@]}"; do
        index="$(echo "$i" | awk '{print $1}')"
        buku -p "$index"
        buku -o "$index"
    done
}

fman() {
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
}
# end misc }
