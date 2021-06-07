FROM matiux/php:8.0-fpm-debian-buster-base

MAINTAINER Matteo Galacci <m.galacci@gmail.com>

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    default-mysql-client \
    git \
    iproute2 \
    locales \
    locales-all \
    mycli \
    nano \
    rsync \
    tzdata \
    ssh \
    sudo \
    vim \
    wget \
    zsh

###> Configurazioni e permessi
ENV TZ=Europe/Rome
RUN locale-gen en_US.UTF-8

RUN echo 'memory_limit = 2048M' >> "$PHP_INI_DIR/conf.d/docker-php-memlimit.ini" \
    && chown -R www-data:www-data /var/www \
    && groupadd -g 1000 utente \
    && useradd -m -u 1000 -g www-data utente \
    && usermod -aG www-data utente

COPY conf/sudo-DEV /etc/sudoers.d/DEV
###> Fine configurazioni e permessi

###> Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
###> Fine composer

###> Configurazione Xdebug
ENV XDEBUG_CONF_FILE=$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
ENV PHP_IDE_CONFIG=serverName=application
RUN chown utente:utente /usr/local/etc/php/conf.d/
COPY --chown=www-data:www-data conf/xdebug.ini $XDEBUG_CONF_FILE

RUN apt-get update && apt-get install -y --no-install-recommends \
    && pecl install xdebug-3.0.4 \
    && docker-php-ext-enable xdebug \
    && sed -i 's/^zend_extension/;zend_extension/g' $XDEBUG_CONF_FILE
###> Fine configurazione Xdebug

###> Pulizia
RUN apt-get remove --purge -y software-properties-common \
    && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
###> Fine pulizia

USER utente

###> Zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

COPY --chown=utente:utente conf/zshrc /home/utente/.zshrc

COPY --chown=utente:utente conf/custom-agnoster.zsh-theme /home/utente/.oh-my-zsh/custom/themes/custom-agnoster.zsh-theme
RUN sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"custom-agnoster\"/" ~/.zshrc \
    && echo "\nexport DEFAULT_USER=utente" >> ~/.zshrc
###> Fine zsh

###> Alias
COPY conf/shell-alias.rc /tmp/shell-alias.rc
RUN cat /tmp/shell-alias.rc >> /home/utente/.zshrc \
    && cat /tmp/shell-alias.rc >> /home/utente/.bashrc
###> Fine alias

###> Configurazione Zsh Autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && sed -i.bak 's/^plugins=(\(.*\)/plugins=(zsh-autosuggestions \1/' ~/.zshrc \
    && echo "\nexport ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"fg=#0cb074\"" >> ~/.zshrc
###> Fine configurazione Zsh Autosuggestions

USER www-data

## per sviluppo da linux
#RUN cat /var/www/.zshrc|sed -e 's/\/var\/www\/.oh-my-zsh/\/home\/utente\/.oh-my-zsh/g' > /home/utente/.zshrc \
#    && cp /home/utente/.zshrc /home/utente/.bashrc \
#    && cp -R /var/www/.oh-my-zsh /home/utente/ \
#    && chown -R utente:www-data /home/utente /etc/php/${PHP_VERSION}/mods-available \
#    && echo "Set disable_coredump false" >> /etc/sudo.conf \
#    && chmod 644 /etc/sudoers.d/DEV