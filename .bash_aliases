# Docker
alias dci="docker images | grep none | awk '{print \$3}' | xargs docker rmi"
alias dp="docker ps -a"
alias di="docker inspect"
alias dim="docker images"

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
