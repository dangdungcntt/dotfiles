alias php8='docker run --rm -it -v $(pwd):/usr/src/app dangdungcntt/php:8.0rc3-cli-composer php'
alias composer8='docker run --rm -it -v $(pwd):/usr/src/app dangdungcntt/php:8.0rc3-cli-composer composer'
alias phpunit8='docker run --rm -it -v $(pwd):/usr/src/app dangdungcntt/php:8.0rc3-cli-composer vendor/bin/phpunit'
