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


alias create-entry="gnome-desktop-item-edit --create-new ~/.local/share/applications"
alias h="sudo vim /etc/hosts"
alias sshconfig="vi ~/.ssh/config"
alias s="cd $HOME/code"
alias cat="bat -p"


# Kubectl
alias k="kubectl"
krh() {
    kubectl rollout history deployment.apps/$1
}

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

dip() { 
    di $1 | jq -r .[0].NetworkSettings.Networks.bridge.IPAddress
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

# Minio
alias mc="docker run --rm -it -v ~/.mc:/root/.mc minio/mc"

# Git
alias pull='git pull'
alias g='git'
alias nah='git reset --hard;git clean -df'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gca='ga && gc'
alias gpo='git push origin'
alias gpoci='git push -o ci.skip origin'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

configGit() {
    git config user.email "dangdungcntt@gmail.com"
    git config user.name "Dung Nguyen Dang"
}

node16() {
    docker run --rm -it -v $(pwd):/home/app -w /home/app -p ${1:-3000}:${1:-3000} node:16-alpine sh
}

# Composer
alias c="composer"
alias cu="composer update"
alias cr="composer require"
alias ci="composer install"
alias cda="composer dump-autoload -o"

# PHP8
alias phpunit='./vendor/bin/phpunit'
alias p='./vendor/bin/pest'
alias pf='p --filter '

# Laravel
alias a='php artisan'

t()
{
    if [ -z "$1" ]
        then
            php artisan tinker
        else
            php artisan tinker --execute="dd($1);"
    fi
}

lstart() {
    VIRTUAL_HOST=$1
    PHP_VERSION=${2:-"7.4"}
    if [ "$#" -ne 1 ]; then
        VIRTUAL_HOST="${PWD##*/}.test"
    fi

    if [ ! -f artisan ]; then
        echo 'Not in Laravel project'
    else 
        IMAGE_NAME=dangdungcntt/php:${PHP_VERSION}-nginx
        CONTAINER_NAME="php-`md5 $(pwd)`"

        if [ -f Dockerfile ]; then
            docker build -t $CONTAINER_NAME .
            IMAGE_NAME=$CONTAINER_NAME
        fi
        
        drm $CONTAINER_NAME -f

        docker run -d \
            --name $CONTAINER_NAME \
            --restart=always \
            --network nginx_docker_network \
            -v $(pwd):/home/app \
            -e VIRTUAL_HOST=$VIRTUAL_HOST \
            -e VIRTUAL_PORT=80 \
            $IMAGE_NAME

        echo "Started container with domain: $VIRTUAL_HOST"
        addVirtualHost $VIRTUAL_HOST
    fi
}

pstart() {
    VIRTUAL_HOST=$1
    if [ "$#" -ne 1 ]; then
        VIRTUAL_HOST="${PWD##*/}.test"
    fi

    CONTAINER_NAME="php-`md5 $(pwd)`"

    drm $CONTAINER_NAME -f

    docker run -d \
        --name $CONTAINER_NAME \
        --restart=always \
        --network nginx_docker_network \
        -v $(pwd):/home/app/public \
        -e VIRTUAL_HOST=$VIRTUAL_HOST \
        -e VIRTUAL_PORT=80 \
        dangdungcntt/php:7.4-nginx

    echo "Started container with domain: $VIRTUAL_HOST"
    addVirtualHost $VIRTUAL_HOST
}

#include custom alias
if [ -f ~/.bash_aliases_custom ]; then
    . ~/.bash_aliases_custom
fi