FROM matiux/php:7.4.2-fpm-buster-base

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    default-mysql-client \
    git \
    iproute2 \
    mycli \
    nano \
    rsync \
    ssh \
    sudo \
    vim \
    wget \
    zsh \
    && pecl install xdebug-2.9.1 \
    && docker-php-ext-enable xdebug \
    && apt-get remove --purge -y software-properties-common \
    && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

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
