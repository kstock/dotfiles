# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# TODO virtualenvwrapper, pyenv
# }

# tool setup related {

# pipx
export PATH=$PATH:$HOME/.local/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# end tool setup related }

# basics {

alias ipy=ipython

alias venv_create='python3 -m venv ./venv'
alias venv_activate='source ./venv/bin/activate'

pyversion(){
    python -c 'import sys; print(sys.version_info[0])'
}

# debugging {
export PYTHONBREAKPOINT=0
alias python_breakpoint_yes='export PYTHONBREAKPOINT=ipdb.set_trace'
alias python_breakpoint_no='export PYTHONBREAKPOINT=0'
# end debugging }

# end basics }

# utility {

# DEPENDS pipx install pypi-server
alias runpypi="pypi-server -vvv -a '.' -P '.'  -p 8080 ~/packages  "

pyhttp(){
     local python_version port
     port=${1:-8811}
     python_version"$(python -c 'import sys; print(sys.version_info[0])')"

     if [[ "$python_version" = 2 ]]; then
        python -m SimpleHTTPServer "$port"
    else
        # assume works >=3 and never gonna hid < 2 version...
        python3 -m http.server "$port"
    fi
}

function wikisum(){
# print out wikipedia summary for $1
# depends: https://github.com/goldsmith/Wikipedia
    python -c "import wikipedia; print wikipedia.summary(\"$1\")"
}
# end utility }


# pip wrappers{

alias pipfreeze='pip freeze > requirements.txt'
function pip-install-save {
    #https://stackoverflow.com/questions/19135867/what-is-pips-equivalent-of-npm-install-package-save-dev
    pip install "$1" && pip freeze | grep "$1" >> requirements.txt
}



function pipsi(){
    #search pip, if version is installed just print version info
    #            otherwise print all output
    res=$(pip search $1)
    tmp=$(echo $res | ack INSTALL -C 1)

    if [[ -z $tmp ]];then
        echo $res
    else
        echo $tmp
    fi
}
# pip}

# virtualenv management {
export WORKON_HOME="$HOME/.virtualenvs"

alias ppy='pipenv run python '

# TODO
export VIRTUALENV_WRAPPER_SCRIPT="/usr/bin/virtualenvwrapper_lazy.sh"
[ -f "$VIRTUALENV_WRAPPER_SCRIPT" ] && source "$VIRTUALENV_WRAPPER_SCRIPT"

function get_virtualenv_name(){
    # Get Virtual Env
    if [[ $VIRTUAL_ENV != "" ]]
        then
          # Strip out the path and just leave the env name
          # sed ensures venv is not ".venv"
          venv="$(echo $VIRTUAL_ENV | sed 's;/.venv;;')"
          venv="${venv##*/}"
    else
          # In case you don't have one activated
          venv=''
    fi
    echo "$venv"
}

# TODO
export GLOBAL_VENV_DIR=~/workspace/pipenvs/globe
export GLOBAL_VENV_BIN_DIR="$GLOBAL_VENV_DIR/.venv/bin"
alias gpy='$GLOBAL_VENV_BIN_DIR/python'
alias gipy='$GLOBAL_VENV_BIN_DIR/ipython'
alias gjup='$GLOBAL_VENV_BIN_DIR/jupyter'
alias gptpy='$GLOBAL_VENV_BIN_DIR/ptpython'
alias gbpy='$GLOBAL_VENV_BIN_DIR/bpython'

# pipenv {

pipenvn(){
    local SYSTEM_PYTHON_VERSION
    SYSTEM_PYTHON_VERSION="$(python --version | awk '{print $2}')"
    set -x
    pipenv --python "$SYSTEM_PYTHON_VERSION"
}

pipenvigc(){
    DIR="$(git rev-parse --show-toplevel)"
    if [[ -z "$DIR" ]];then
        echo "not a git repo quiting"
        return 1
    fi

    pipenv install $@
    git add $DIR/Pipfile $DIR/Pipfile.lock
    git status -uno
    MSG="chore(dep):$@"
    echo "$MSG"
    git commit -m "$MSG"

}
# end pipenv }

# poetry {
poetryigc(){
    DIR="$(git rev-parse --show-toplevel)"
    if [[ -z "$DIR" ]];then
        echo "not a git repo quiting"
        return 1
    fi

    poetry add $@
    git add $DIR/pyproject.toml $DIR/poetry.lock
    git status -uno
    MSG="chore(dep):$@"
    echo "$MSG"
    git commit -m "$MSG"

}
alias poetry_needs_update="poetry update --dry-run | grep '\->'"
# end poetry }
# end virtualenv management }
