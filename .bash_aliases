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
alias gpo='git push origin'

configGit() {
    git config user.email "dangdungcntt@gmail.com"
    git config user.name "Dung Nguyen Dang"
}
configGitEway() {
    git config user.email "dungnd@eway.vn"
    git config user.name "DungND"
}

# PHP
alias php='docker run --rm -it -v $(pwd):/home/app dangdungcntt/php:7.4-nginx php'
alias composer='docker run --rm -it -v $HOME/.composer:/root/.composer -v $(pwd):/home/app dangdungcntt/php:7.4-nginx composer'
alias phpunit='docker run --rm -it -v $(pwd):/home/app dangdungcntt/php:7.4-nginx vendor/bin/phpunit'

# PHP8
alias php8='docker run --rm -it -v $(pwd):/usr/src/app dangdungcntt/php:8.0rc3-cli-composer php'
alias composer8='docker run --rm -it -v $(pwd):/usr/src/app dangdungcntt/php:8.0rc3-cli-composer composer'
alias phpunit8='docker run --rm -it -v $(pwd):/usr/src/app dangdungcntt/php:8.0rc3-cli-composer vendor/bin/phpunit'

# Laravel
alias a='php artisan'
lstart() {
    VIRTUAL_HOST=$1
    if [ "$#" -ne 1 ]; then
        VIRTUAL_HOST="${PWD##*/}.test"
    fi

    if [ ! -f artisan ]; then
        echo 'Not in Laravel project'
    else 
        CONTAINER_NAME="php-`md5 $(pwd)`"

        drm $CONTAINER_NAME -f

        docker run -d \
            --name $CONTAINER_NAME \
            --restart=always \
            --network nginx_docker_network \
            -v $(pwd):/home/app \
            -e VIRTUAL_HOST=$VIRTUAL_HOST \
            -e VIRTUAL_PORT=80 \
            dangdungcntt/php:7.4-nginx

        echo "Started container with domain: $VIRTUAL_HOST"
        addVirtualHost $VIRTUAL_HOST
    fi
}
