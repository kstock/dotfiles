# shellcheck disable=SC1073,SC2148
# Modeline and Notes {
# vim: set foldmarker={,} foldlevel=1 foldmethod=marker:
# }
#
# TODO dex , kmac k8s aliases
# Docker {

# Get latest container ID
alias dl="docker ps -l -q"

alias dps="docker ps"
alias dpa="docker ps -a"

alias di="docker images"

# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"

# Stop all containers
dstopall() { docker stop $(docker ps -a -q); }

function dsfzf() {
# Select a running docker container to stop
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

function dattachfzf() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Remove all containers
drmall() { docker rm $(docker ps -a -q); }
# Select a docker container to remove
function drmfzf() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm "$cid"
}

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias drmidangling='docker rmi $(di -f dangling=true -q)'

# Remove all images
dri() { docker rmi $(docker images -q); }

# Dockerfile build, e.g., $dbu tcnksm/test
dbu() { docker build -t="$1" .; }

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Bash into running container
# TODO dexd
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

#
# end Docker alias and function }

# k8s {
function kexf(){
    local POD
    local EXTRA
    EXTRA=${1:-Running}

    POD="$(kubectl get pods| grep -E "$EXTRA" | fzf | cut -d" " -f1)"
    if [[ ! -z "$POD" ]];then
        kubectl exec -it "$POD" /bin/sh
        #kubectl exec -it "$POD" /bin/bash # some docker do not have bash
    fi
}


alias k='kubectl'

alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kdp='kubectl delete pod '

alias kgl='kubectl logs'

alias kgpvc='kubectl get pvc'
alias kdpvc='kubectl delete pvc'

# DEPENDS kubetail https://github.com/johanhaleby/kubetail
alias kt=kubetail

# end k8s }
