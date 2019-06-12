FROM matiux/php:5.3.29-apache2-jessie-base

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    mysql-client \
    nano \
    rsync \
    ssh \
    sudo \
    vim \
    wget \
    zsh \
    && apt-get remove --purge -y software-properties-common \
    && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Xdebug
COPY conf/xdebug.ini /tmp/xdebug.ini
ENV XDEBUG_CONF_FILE=$PHP_INI_DIR/conf.d/xdebug.ini
RUN pecl install xdebug-2.2.7 \
    && echo ";zend_extension=$(find / -iname xdebug.so)" >> $XDEBUG_CONF_FILE \
    && cat /tmp/xdebug.ini >> $XDEBUG_CONF_FILE
RUN chown utente:utente $PHP_INI_DIR/conf.d
ENV PHP_IDE_CONFIG="serverName=application"
ENV XDEBUG_CONFIG="idekey=PHPSTORM"


#Php configs
RUN echo 'memory_limit = 512M' >> $PHP_INI_DIR/php.ini

#Zsh
USER utente

COPY conf/custom_zshrc /home/utente
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'source ~/custom_zshrc' >> /home/utente/.zshrc

USER root