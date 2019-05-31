FROM matiux/php:7.3.5-fpm-alpine3.9-base

USER root

RUN apk --no-cache add \
    bash \
    curl \
    mysql-client \
    nano \
    openssh \
    rsync \
    sudo \
    vim \
    wget \
    zsh \   
    && apk add --no-cache --virtual .xdebug-build-deps \
    $PHPIZE_DEPS \
    && pecl install xdebug-2.7.1 \
    && docker-php-ext-enable xdebug \
    && apk del .xdebug-build-deps \
    && pecl clear-cache \
    && docker-php-source delete \
    && echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

#Xdebug
RUN chown utente:utente /usr/local/etc/php/conf.d/
COPY conf/xdebug.ini /tmp/xdebug.ini
RUN cat /tmp/xdebug.ini >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN sed -i "s/xdebug\.remote_host=.*/xdebug\.remote_host="$(/sbin/ip route|awk '/default/ { print $3 }')"/" /usr/local/etc/php/conf.d/xdebug.ini
ENV PHP_IDE_CONFIG=serverName=application

USER utente

COPY conf/custom_zshrc /home/utente
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'source ~/custom_zshrc' >> /home/utente/.zshrc