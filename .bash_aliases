# Helper

md5() {
    echo -n $1 | md5sum | awk '{print $1}'
}

addVirtualHost() {
    FOUND=`grep "127.0.0.1       $1" /etc/hosts`
    if [ "$FOUND" != "" ]; then
        echo "Host $1 existed in /etc/hosts"
    else 
        echo "127.0.0.1       $1 #auto add" | sudo tee -a /etc/hosts > /dev/null
        echo "Added host $1 to /etc/hosts"
    fi
}

# Get public key fingerprint
sshfg() {
    ssh-keygen -E ${1:-md5} -lf ~/.ssh/id_rsa.pub
}

alias create-entry="gnome-desktop-item-edit --create-new ~/.local/share/applications"
alias h="sudo vim /etc/hosts"
alias sshconfig="vim ~/.ssh/config"
alias cd="z"
alias s="cd $HOME/code"
alias cat="bat -p"
alias topsize="du -h -d 1 | sort -rh | head -n"


# Kubectl
alias k="kubectl"

# Terraform
alias tf="terraform"

# Docker
alias dl="docker logs"
alias dp="docker ps -a"
alias di="docker inspect"
alias dim="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dci="docker images | grep none | awk '{print \$3}' | xargs docker rmi"
alias dcia="docker images | awk '{print \$3}' | xargs docker rmi"
alias dcv="docker volume rm \$(docker volume ls -q --filter dangling=true)"
alias dcc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

dip() { 
    di $1 | jq -r '.[0].NetworkSettings.IPAddress'
}
de() { 
    docker exec -ti $1 sh
}
deb() { 
    docker exec -ti $1 bash
}
dcig() {
    docker images | grep $1 | awk '{print $3}' | xargs docker rmi
}

# Node
alias nt="npm run test"

# Minio
alias mc="docker run --rm -it -v ~/.mc:/root/.mc minio/mc"

# psql
alias psql="docker run -ti --rm alpine/psql"

# Git
alias p='git pull'
alias gf='git fetch'
alias g='git'
alias nah='git reset --hard;git clean -df'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gca='ga && gc'
alias gpo='git push origin'
alias gpoci='git push -o ci.skip origin'
alias glog="git log --graph --oneline --all"
alias glogo="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

setupGolangHook() {
    hook_file=".git/hooks/pre-commit"
    force_override=false

    while getopts ":f" opt; do
        case ${opt} in
            f )
            force_override=true
            ;;
            \? )
            echo "Invalid option: -$OPTARG" 1>&2
            return 1
            ;;
        esac
    done

    if [ -f "$hook_file" ] && [ "$force_override" = false ]; then
        echo "$hook_file already exists, skipping creation."
        return
    fi

    mkdir -p .git/hooks

    echo "#!/bin/bash" > "$hook_file"
    echo "sed -i '' '/^replace /s/^/\/\//' go.mod" >> "$hook_file"
    echo "git add go.mod" >> "$hook_file"
    echo "golangci-lint fmt" >> "$hook_file"
    echo "golangci-lint run" >> "$hook_file"
    chmod +x "$hook_file"
    echo "Created $hook_file"
}

addGitAttributes() {
    curl -Os https://raw.githubusercontent.com/dangdungcntt/dotfiles/master/.gitattributes
    git add --update --renormalize
}

configGit() {
    git config user.email "dangdungcntt@gmail.com"
    git config user.name "Dung Nguyen Dang"
}

#include custom alias
if [ -f ~/.bash_aliases_custom ]; then
    . ~/.bash_aliases_custom
fi
