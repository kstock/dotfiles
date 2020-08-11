# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker filetype=zsh:
# }

# setup boilerplate {
autoload -U colors && colors
autoload -U promptinit && promptinit

setopt promptsubst
# end setup boilerplate }

## TODO
#ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

#divider="|"

# ssh {

# detect if ssh
# https://unix.stackexchange.com/questions/9605/how-can-i-detect-if-the-shell-is-controlled-from-ssh
CUR_USR=""
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    CUR_USR="$(hostname)""@"
fi

# end ssh }

RESET_COLOR="{$reset_color%}"
CUR_TIME="%{$fg[red]%}%T%"$RESET_COLOR
CUR_DIR="%{$fg[blue]%}%c%"$RESET_COLOR
CUR_USR="(%{$fg[white]%}$CUR_USR%n)%"$RESET_COLOR


# git {
# BRANCH=$(git symbolic-ref HEAD | cut -d'/' -f3 2>/dev/null)
# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# If inside a Git repository, print its branch and state
# https://gist.github.com/joshdick/4415470
GIT_PROMPT_PREFIX="%{$fg[red]%}("
GIT_PROMPT_SUFFIX=")%{$reset_color%}"
git_prompt_string() {

  if typeset -f git_super_status > /dev/null; then
      local git_where="$(parse_git_branch)"
      #[ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
      [ -n "$git_where" ] && echo "$(git_super_status)"
  fi
}

# git_super_status overrides from when unicode was fucked in xterm
#export ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{S%G%}"
#export ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{x%G%}"
#export ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{C%G%}"
#export ZSH_THEME_GIT_PROMPT_BEHIND="%{B%G%}"
#export ZSH_THEME_GIT_PROMPT_AHEAD="%{A%G%}"
#export ZSH_THEME_GIT_PROMPT_UNTRACKED="%{U%G%}"
#export ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{G%G%}"

GIT_STUFF='$(git_prompt_string)'
#GIT_STUFF='$(git_super_status)'
#GIT_STUFF=""
#git_where="$(parse_git_branch)"
#if  [[ -n "$git_where" ]]; then
#    GIT_STUFF='"$(git_super_status)"'
#fi
# end git }

# venv {

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info(){
    # https://stackoverflow.com/questions/10406926/how-do-i-change-the-default-virtualenv-prompt
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        # sed ensures venv is not ".venv" poetry had this issue
        venv="$(echo $VIRTUAL_ENV | sed 's;/.venv;;')"
        #echo ${VIRTUAL_ENV/\/.venv/}  # this syntax nicer?
        venv="${venv##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "($venv) "
}

VENV='$(virtualenv_info)'
# end venv }

# nprocs backgrounded {
#
#https://stackoverflow.com/questions/10194094/zsh-prompt-checking-if-there-are-any-background-jobs
#man zshmisc in "expansion of prompt sequences" section (the ternary operation is in "conditional substrings in prompts" subsection). –
NPROC="%(1j.[%j].)"

# end nprocs backgrounded }


# final ps1 {

PS1=$VENV$CUR_TIME$CUR_USR$CUR_DIR${GIT_STUFF}$NPROC

# end final ps1 }
