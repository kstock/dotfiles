# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
#
# TODO _send_command_to_tmux_session, tmuxp, window/pane reorg
#
alias ta='tmux attach'
alias tnew='tmux new -s '
tas(){
    # attach or create new session with session_name (defaults to user name)
    local session_name="${1:-$USER}"
    tmux attach -t "$session_name" || tmux new -s "$session_name"
}

alias tmux_layout_undo='tmux select-layout -o'


# splits down middle instead of active pane
# |_|_|  -> |__|__|  NOT |   |___|
#           |_____|      |___|___|
alias tmux_split_full='tmux split-window -f'

# |_____| my favorite layout
# |__|__|
alias tmux_mywindow='tmux new-window \; split-window -p 20 \; split-window -h'


# useful for quickly minimizing panes you still want partially focussed
function tsmally(){
    local NEWSIZE=${1:-20}
    set -x
    tmux resize-pane -y "$NEWSIZE"
}
function tsmallx(){
    local NEWSIZE=${1:-20}
    set -x
    tmux resize-pane -x "$NEWSIZE"
}


# TODO
_send_command_to_tmux_session() {
    # only difference with _send_command_to_tmux_window is
    # -t ${input_session} in for loop
    # but leaving in case is useful at some point
    # switching the arg order would require more parsing or not using $@ due to quoting

    # https://stackoverflow.com/questions/16325449/how-to-send-a-command-to-all-panes-in-tmux
    if [[ $# -eq 0 || "$1" = "--help" ]] ; then
        echo 'Usage: _send_command_to_tmux_session $session_name what ever command you want: '
        return
    fi
    current_session="$(tmux display-message -p '#S')"
    input_session="$1"
    input_command="${@:2}"
    for _pane in $(tmux list-panes -s -t ${input_session} -F '#{window_index}.#{pane_index}'); do
        # only apply the command in bash or zsh panes.
        _current_command=$(tmux display-message -p -t ${input_session}:${_pane} '#{pane_current_command}')
        if [ ${_current_command} = zsh ] || [ ${_current_command} = bash ] ; then
            echo "${input_session}:${_pane} $_current_command"
            tmux send-keys -t ${_pane} "${input_command}" Enter
        fi
    done
}

_send_command_to_tmux_window() {
    # https://stackoverflow.com/questions/16325449/how-to-send-a-command-to-all-panes-in-tmux
    if [[ $# -eq 0 || "$1" = "--help" ]] ; then
        echo 'Usage: _send_bash_command_to_session $command what ever command you want: '
        return
    fi
    input_command="$1"
    for _pane in $(tmux list-panes -F '#{window_index}.#{pane_index}'); do
        # only apply the command in bash or zsh panes.
        _current_command=$(tmux display-message -p -t :${_pane} '#{pane_current_command}')
        if [ ${_current_command} = zsh ] || [ ${_current_command} = bash ] ; then
            echo "${input_session}:${_pane} $_current_command"
            tmux send-keys -t ${_pane} "${input_command}" Enter
        fi
    done
}

tmux_sync_windows() {
    # an alternative is
    # Ctrl-B :
    # setw synchronize-panes on
    # clear history

    # this does not cd for windows running processes besides zsh/bash
    _send_command_to_tmux_window "cd $PWD"
}

function reload_all_panes(){
    input_command="$1"
    _current_session=$(tmux display-message -p '#{session_name}')
    _send_command_to_tmux_session $_current_session $input_command1
}

# TODO
tmux_move_pane_fzf(){
    local WINDOW WINDEX

    WINDOW="$(tmux list-windows | fzf)"
    WINDEX=":$(echo $WINDOW | perl -pe 's/:.*//')"
    set -x
    tmux join-pane -t "$WINDEX"
}

tmux_move_winstash_to(){
    # fuzzy select then move pane to window named "winstash"
    local src_pane winstash_winid

    src_pane="$(tmux list-panes -F '#{window_index}.#{pane_index}|#{pane_current_command}' | fzf --prompt 'pane to move')"
    if [[ -z "$src_pane" ]];then
        return
    fi
    src_pane="$(echo $src_pane | cut -d '|' -f 1)"

    winstash_winid="$(tmux list-windows -F '#I|#W' | grep winstash | cut -d '|' -f 1)"
    if [[ -z "$winstash_winid" ]];then
        echo "error! no winstash window!"
    else
        set -x
        tmux join-pane -d -s "$src_pane" -t "$winstash_winid"
    fi
}

tmux_move_winstash_from(){
    # fuzzy select then move pane to window named "winstash"
    local src_pane winstash_winid cur_windex

    winstash_winid="$(tmux list-windows -F '#I|#W' | grep winstash | cut -d '|' -f 1)"
    if [[ -z "$winstash_winid" ]];then
        echo "error! no winstash window!"
    fi

    src_pane="$(tmux list-panes -t :$winstash_winid -F '#{window_index}.#{pane_index}|#{pane_current_command}' | fzf --prompt 'pane to move')"
    if [[ -z "$src_pane" ]];then
        return
    fi
    src_pane="$(echo $src_pane | cut -d '|' -f 1)"

    cur_windex="$(tmux display-message -p '#{window_index}')"
    set -x
    tmux join-pane -d -s "$src_pane" -t "$cur_windex"

}
