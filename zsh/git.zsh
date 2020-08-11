#( shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
# TODO git log, doc stuff like gitoldmsg gitcommitfunctions, gcmb() etc
# aliases3 {
#
# add {
#
alias ga='git add '
alias gap='git add -p '
alias gau='git add -u'
alias gapp='git add -p .'
alias garm='git ls-files --deleted -z  | xargs -0 git rm' # stage all deleted files

# add }
#
# commit {
alias gc='git commit '
alias gcm='git commit -m '

alias gca='git commit --amend '
alias gcan='git commit --amend --no-edit'

alias gac='git add . && git commit -m '
# commit }

# diff {
alias gd='git diff '
alias gdl='git show HEAD' # diff last
alias gdc='git diff --cached '

alias gds='git diff --ignore-all-space'
alias gdst='git diff --stat '
# diff }

# status {
alias gst='git status'
alias gstu='git status -uno'
alias gstnrm='git status -uno  | grep -v deleted ' # status of tracked non deleted files
# status }

# log {
alias gl='git log --graph --pretty=medium --decorate '
alias gls='git log --graph --pretty=medium --decorate --simplify-by-decoration '
alias gl1='git log --graph --pretty=medium --decorate --oneline'
alias glsc='git log --oneline --decorate | fzf | cut -d" " -f1 | xclip' # git log select commit hash
alias gltd='gl --since="6am"'
alias gl1p='git log --graph --pretty=medium --decorate --first-parent' #
alias glg="git log --graph --pretty=format:'%C(bold)%h%Creset  %C(cyan)(%cr)%Creset  %C(magenta)%d%Creset %s' --abbrev-commit --date=relative"
# log }

alias gitignoreuntracked='git status -s | grep -e "^\?\?" | grep -v ".gitignore" | cut -c 4- >> .gitignore'


alias gco='git checkout  '
alias gcb='git checkout -b '

alias gpu='git push '


alias gf='git fetch'
alias gcl='git clone '

alias gb='git branch -vv'
alias gbb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(authordate:short)|%(color:red)%(objectname:short)|%(color:yellow)%(refname:short)%(color:reset)|(%(color:green)%(committerdate:relative)%(color:reset))|%(color:red)%(upstream:track)%(color:reset)%(contents:subject)' --color=always | column -t -s '|'"


# fshow - git commit browser
function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}


function gitoldmsg(){
    # TODO
    # https://robots.thoughtbot.com/autosquashing-git-commits
    # https://git-scm.com/docs/pretty-formats
    PREVMSG="$(git log --format='format:%s' | fzf)"

    if [[ ! -z "$PREVMSG" ]];then
        git commit --fixup ":/$PREVMSG"
    fi

    # fzf wiki has this tho relies on unknown alias git ll
    # git ll -n 20 | fzf | cut -f 1 | xargs git commit --no-verify --fixup
}

function gitcommitfunctions(){
    # TODO
    local MSG="$(git diff --cached | grep '+.*def' | perl -pe 's/^\+ *def ([^(]*).*/\1/' | perl -pe 's/\n/ /' | perl -pe 's/ $//')"
    if [[ -z "$MSG" ]];then
        echo "msg empty"
        return
    fi
    local MSG="$1""added functions - $MSG"
    local MSG="$(echo $MSG | vipe)"
    git commit -m "$MSG"
}
function gitcommit_oldedits(){
    git commit -m "old edits. $1"
}



git_reorder_last_2_commits() {
# https://stackoverflow.com/questions/33388210/how-to-reorder-last-two-commits-in-git
    echo '----------previous'
    git log --oneline -n 2
    GIT_SEQUENCE_EDITOR="sed -i -n 'h;1n;2p;g;p'" git rebase -i HEAD~2
    echo '----------now'
    git log --oneline -n 2
}

# TODO needed?
alias git_last_commit_reltime='git log --pretty=format:'%cr'  --date=relative -n 1'
function minutes_since_last_commit {
    DOC="https://gist.github.com/joshwalsh/778558"
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}

# TODO
function gmergetag(){ git merge --no-ff "$1" && git tag "$1" && git branch -d "$1"}

# TODO
# git lines of code
function gloc(){
    git log --pretty=tformat: $@ --numstat | gawk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }'
}
#

# TODO dep forgit
export FORGIT_NO_ALIASES=1
alias gaf='forgit::add'
alias glo='forgit::log'
alias gdf='forgit::diff'
alias gi='forgit:ignore'
alias gstf='forgit::stash::show'
#alias gcf='forgit::restore'
#alias gclean='forgit::clean'


#
#
function git_diff_my_last_commit(){
    #TODO
    set -x
    # AUTHOR="$(git config user.name)"
    AUTHOR='kstock'
    MY_LAST_COMMIT=$(git log --author "$AUTHOR" --pretty=format:"%h" -1)
    git diff $MY_LAST_COMMIT $@
}

function git_file_at_commit(){
# git_file_at_commit 559e1ab64fc3da016c3e892dd3f90ff90e9dae82:src/main.py | pygmentize
set -x
git show "$1:$2" | pygmentize | less -R
}


gacm(){
    git add -uno .
    helper_git_conditional_add "$1"
}

gacm(){
    git add .
    helper_git_conditional_add "$1"
}

helper_git_conditional_add(){
    # TODO https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
    MSG="$1"
    git diff --cached --stat
    git commit -m "$MSG"
}

gitmergemaster(){
    set -x
    GBRANCH="$(git symbolic-ref --short HEAD)"
    git checkout master
    git merge --no-ff "$GBRANCH"
    git branch -d "$GBRANCH"
}

gclcd() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

function cdgr(){
    DIR="$(git rev-parse --show-toplevel)"
    cd "$DIR"
    echo "cd $DIR"
}

fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}


function add_ghook(){
    # TODO
    #cp $HOME/workspace/githooks/commit-msg .git/hooks/
    ln -s  $HOME/workspace/githooks/commit-msg .git/hooks/commit-msg
}
# TODO
function gcmr(){ git commit -m "refactor:$1"}
function gcmf(){ git commit -m "feat:$1"}
function gcmm(){ git commit -m "minor:$1"}
function gcmb(){ git commit -m "bugfix:$1"}
function gcmc(){ git commit -m "chore:$1"}
function gcmt(){ git commit -m "testing:$1"}
function gcmtw(){ git commit -m "tweak:$1"}
function gcmchk(){ git commit -m "chkpnt:$1"}
function gcmd(){ git commit -m "docs:$1" }

alias tig1p='tig --first-parent -m'
