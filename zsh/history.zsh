# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
#
# history management stuff

# aliases {
# display last lines of history with numbers by then
# for making history subsitutions like "!-3" easier to track
# per directory history can break this a bit
# 2014-12-06 shellcheck does not recognize $1 params are quoted away, give no params in alias error
# $ hn -2
# -3 10133  12/6/2014 17:29  ls
# -2 10134  12/6/2014 17:29  echo
#
alias hn='history | awk "{print \$1- ($HISTCMD + 1), \$0}" | tail'
alias hnl='history | awk "{print \$1-($HISTCMD + 1), \$0}"'

# TODO some are in aliases bc of CHOSEN_GREP_PROG
alias hi='history -i -D'
# end aliases }

# env {
export HISTFILE=~/.history
export SAVEHIST=10000
export HISTSIZE=10000
# end env }

# setopts {
# Killer: share history between multiple shells
setopt SHARE_HISTORY

# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

# space prefix means ignore in history
setopt histignorespace

setopt hist_expire_dups_first

# Don't overwrite, append!
setopt APPEND_HISTORY

# Write after each command
# setopt INC_APPEND_HISTORY

# setopts}
