#!/usr/bin/env bash

#WORKDIR=$(docker-compose --file docker/docker-compose.yml run --rm -u utente php pwd)
WORKDIR=/var/www/app
PROJECT_NAME=$(basename $(pwd) | tr  '[:upper:]' '[:lower:]')
COMPOSE_OVERRIDE=
PHP_CONTAINER=

#isPhpServiceUp() {
#
#    IS_RUNNING=`docker-compose \
#        --file docker/docker-compose.yml \
#        ${COMPOSE_OVERRIDE} \
#        -p ${PROJECT_NAME} \
#        ps -q php`
#
#    if [[ "$IS_RUNNING" != "" ]]; then
#        return 1
#    fi
#}

copyHostData() {

    mkdir -p docker/php/git/
    cp ~/.gitconfig docker/php/git/

    if [[ ! -d docker/php/ssh ]]; then
        mkdir -p docker/php/ssh
        cp ~/.ssh/id_rsa docker/php/ssh/
        cp ~/.ssh/id_rsa.pub docker/php/ssh/
    fi
}

if [[ -f "docker/docker-compose.override.yml" ]]; then
    COMPOSE_OVERRIDE="--file docker/docker-compose.override.yml"
fi

if [[ "$1" = "composer" ]]; then

    shift 1
    docker-compose \
        --file docker/docker-compose.yml \
        -p ${PROJECT_NAME} \
        ${COMPOSE_OVERRIDE} \
        run \
        --rm \
        -u utente \
        -v ${PWD}:/var/www/app \
        -w ${WORKDIR} \
        ${PHP_CONTAINER} \
        composer $@

elif [[ "$1" = "up" ]]; then

    shift 1

    copyHostData

    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        up $@

elif [[ "$1" = "build" ]]; then

    shift 1

    copyHostData

    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        build ${PHP_CONTAINER}

elif [[ "$1" = "enter-root" ]]; then

    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        exec \
        -u root \
        php /bin/bash

elif [[ "$1" = "enter" ]]; then

    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        exec \
        -u utente \
        -w ${WORKDIR} \
        php /bin/bash

elif [[ "$1" = "down" ]]; then

    shift 1
    docker-compose \
	    --file docker/docker-compose.yml \
	    ${COMPOSE_OVERRIDE} \
	    -p ${PROJECT_NAME} \
		down $@

elif [[ "$1" = "purge" ]]; then

    docker-compose \
	    --file docker/docker-compose.yml \
	    ${COMPOSE_OVERRIDE} \
	    -p ${PROJECT_NAME} \
		down \
        --rmi=all \
        --volumes \
        --remove-orphans

elif [[ "$1" = "log" ]]; then

    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        logs -f

elif [[ $# -gt 0 ]]; then
    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        "$@"

else
    docker-compose \
        --file docker/docker-compose.yml \
        ${COMPOSE_OVERRIDE} \
        -p ${PROJECT_NAME} \
        ps
fi