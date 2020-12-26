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
alias hostfile="sudo vim /etc/hosts"

# Docker
alias dl="docker logs"
alias dp="docker ps -a"
alias di="docker inspect"
alias dim="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dci="docker images | grep none | awk '{print \$3}' | xargs docker rmi"

dip() { 
    di $1 | jq -r .[0].NetworkSettings.Networks.bridge.IPAddress
}
de() { 
    docker exec -ti $1 sh
}
deb() { 
    docker exec -ti $1 bash
}

# Git
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
configGitEway() {
    git config user.email "dungnd@eway.vn"
    git config user.name "DungND"
}

# Node
if ! command -v node > /dev/null; then
    alias node='docker run --rm -it -v $(pwd):/home/app -w /home/app node:lts-alpine3.10 node'
fi

if ! command -v npm > /dev/null; then
    alias npm='docker run --rm -it -v $(pwd):/home/app -w /home/app node:lts-alpine3.10 npm'
fi

nodep() {
    docker run --rm -it -v $(pwd):/home/app -w /home/app --expose $1 -e VIRTUAL_HOST=node.test --network nginx_docker_network node:lts-alpine3.10 node ${@:2}
}
nodepd() {
    docker run --rm -it -v $(pwd):/home/app -w /home/app --expose $1 -e VIRTUAL_HOST=$2 --network nginx_docker_network node:lts-alpine3.10 node ${@:3}
}

# PHP
if ! command -v php > /dev/null; then
    alias php='docker run --rm -it -v $(pwd):/home/app dangdungcntt/php:7.4-cli-alpine php'  
fi

if ! command -v composer > /dev/null; then
    alias composer='docker run --rm -it -v $HOME/.composer:/root/.composer -v $(pwd):/home/app -e XDEBUG_MODE=coverage dangdungcntt/php:7.4-cli-xdebug composer'
fi

if ! command -v phpunit > /dev/null; then
    alias phpunit='docker run --rm -it -v $(pwd):/home/app dangdungcntt/php:7.4-cli-xdebug -e XDEBUG_MODE=coverage vendor/bin/phpunit'
fi

alias c="composer"
alias cu="composer update"
alias cr="composer require"
alias ci="composer install"
alias cda="composer dump-autoload -o"

# PHP8
alias php8='docker run --rm -it -v $(pwd):/home/app dangdungcntt/php:8.0.0-cli-alpine php'
alias composer8='docker run --rm -it -v $(pwd):/home/app -v ~/.composer8:/root/.composer -e XDEBUG_MODE=coverage dangdungcntt/php:8.0-cli-xdebug composer'
alias laravel8='docker run --rm -it -v $(pwd):/home/app -v ~/.composer8:/root/.composer -e XDEBUG_MODE=coverage dangdungcntt/php:8.0-cli-xdebug laravel'
alias phpunit8='docker run --rm -it -v $(pwd):/home/app -e XDEBUG_MODE=coverage dangdungcntt/php:8.0-cli-xdebug vendor/bin/phpunit'
alias pf8='phpunit8 --filter '

# Laravel
alias a='php artisan'
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
