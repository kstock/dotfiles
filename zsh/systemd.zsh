# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
alias sys=systemctl
alias syss='systemctl status '
alias sysstart='sudo systemctl start '
alias sysstop='sudo systemctl stop '

# restart then watch status
sysres(){
    if [[ -z "$1" ]];then
        echo "need param"
        return
    fi
    local APP;
    APP="$1"
    systemctl restart "$APP"
    watch "systemctl status $APP"
}
