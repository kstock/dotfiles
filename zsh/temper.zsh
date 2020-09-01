# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }


viman(){
    # https://github.com/vim-utils/vim-man
    nvim -c ":Man $1 $2" -c "silent only"
}
