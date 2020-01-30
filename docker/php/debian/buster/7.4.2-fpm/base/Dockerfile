FROM php:7.4.2-fpm-buster

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      libicu-dev \
      libmemcached-dev \
      libmemcached11 \
      libncurses5-dev \
      libxml2 \
      libzip-dev \
      unzip \
      zip \
      zlib1g-dev \
    && pecl install -o \
        memcached-3.1.5 \
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
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

WORKDIR /var/www/app

RUN mkdir /home/utente \
    && groupadd -g 1000 utente \
    && useradd -u 1000 --gid 1000 -d /home/utente -s /bin/bash utente \
    && usermod -a -G www-data utente \
    && chown utente /home/utente \
    && curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin --filename=composer \
      --version 1.9.2

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
