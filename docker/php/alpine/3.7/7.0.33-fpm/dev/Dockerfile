FROM matiux/php:7.0.33-fpm-alpine3.7-base

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
ENV XDEBUG_CONF_FILE=$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
RUN chown utente:utente /usr/local/etc/php/conf.d/
COPY conf/xdebug.ini /tmp/xdebug.ini
RUN cat /tmp/xdebug.ini >> $XDEBUG_CONF_FILE \
    && sed -i 's/^zend_extension/;zend_extension/g' $XDEBUG_CONF_FILE
ENV PHP_IDE_CONFIG=serverName=application

USER utente

COPY conf/custom_xrc /home/utente
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'source ~/custom_xrc' >> /home/utente/.zshrc \
    && echo 'source ~/custom_xrc' >> /home/utente/.bashrc