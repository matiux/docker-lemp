FROM php:7.3.6-fpm-alpine3.10

RUN apk add --no-cache \
        git \
        icu-dev \
        libmemcached-libs \
        zlib-dev \
        libzip-dev \
    && apk add --no-cache --virtual .ext-build-deps \
        autoconf \
        g++ \
        gcc \
        libc-dev \
        libmemcached-dev \
        make \
    && pecl install -o \
        memcached-3.1.3 \
    && docker-php-ext-enable \
        memcached \
    && docker-php-ext-install -j5 \
        #`-j` è come per make, per usare 5 thread, accelera la compilazione
        #la regola è che è sempre meglio averla più alta del numero di core a disposzione. La sfiga è che non
        #si può parametrizzare, o ti si invalida la cache della build perché Docker vede un'istruzione diversa
        #(se cambi il parametro)
        bcmath \
        intl \
        json \
        opcache \
        pdo_mysql \
        zip \
    && apk del .ext-build-deps

WORKDIR /var/www/app

RUN adduser -D -u 1000 utente \
    && adduser utente www-data \
    && chown -R utente /home/utente \
    && chown -R utente /var/www/app \
    && curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin --filename=composer \
        --version 1.8.6

ENV PHP_INI_DIR /usr/local/etc/php

USER utente

ARG GITHUB_TOKEN
# ARG BITBUCKET_CONSUMER_KEY
# ARG BITBUCKET_CONSUMER_SECRET

RUN composer config -g github-oauth.github.com $GITHUB_TOKEN \
#     && composer config -g bitbucket-oauth.bitbucket.org.consumer-key $BITBUCKET_CONSUMER_KEY \
#     && composer config -g bitbucket-oauth.bitbucket.org.consumer-secret $BITBUCKET_CONSUMER_SECRET \
    && composer global require \
        --no-suggest --no-interaction \
        hirak/prestissimo \
    && rm -rf ~/.composer/cache