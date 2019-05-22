FROM php:7.3.5-fpm-stretch

# LABEL mantainer="m.galacci@gmail.com"

# ARG HOST_UID
# ARG HOST_GID

# ENV HOST_UID ${HOST_UID:-1000}
# ENV HOST_GID ${HOST_GID:-1000}

# RUN apt-get update && apt-get install -y software-properties-common  \
#       build-essential pkg-config make git g++ gcc \
#       libmemcached-dev libmsgpack-dev libmsgpackc2 zlib1g zlib1g-dev \
#       vim vim-gtk3 \
#       supervisor acl \
#       iproute2 \
#       libmcrypt-dev libreadline-dev \
#       php-pear \
#       php-xdebug \
#       php-memcached \
#       php7.2 php7.2-fpm php7.2-bcmath \
#       php7.2-intl \
#       php7.2-bz2 php7.2-cgi php7.2-cli \
#       php7.2-common php7.2-curl php7.2-dev \
#       php7.2-imap php7.2-json php7.2-mbstring \
#       php7.2-mysql php7.2-opcache \
#       php7.2-readline php7.2-sqlite3 php7.2-xml php7.2-zip \
#       && mkdir /run/php \
#       && apt-get remove --purge -y software-properties-common \
#       && apt-get autoremove -y \
#       && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#       && pecl install mcrypt-1.0.1

# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# RUN sed -i "s/display_errors = Off/display_errors = On/" /etc/php/7.2/fpm/php.ini && sed -i "s/display_errors = Off/display_errors = On/" /etc/php/7.2/cli/php.ini \
#     && sed -i -e 's/listen = \/run\/php\/php7.2-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/7.2/fpm/pool.d/www.conf \
#     && sed -i -e 's/;daemonize = yes/daemonize = no/g' /etc/php/7.2/fpm/php-fpm.conf \
#     && sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini && sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/cli/php.ini \
#     && sed -i -e 's/;date.timezone =/date.timezone = "Europe\/Rome"/g' /etc/php/7.2/fpm/php.ini && sed -i -e 's/;date.timezone =/date.timezone = "Europe\/Rome"/g' /etc/php/7.2/cli/php.ini \
#     && echo "extension=mcrypt.so" >> /etc/php/7.2/fpm/php.ini && echo "extension=mcrypt.so" >> /etc/php/7.2/cli/php.ini \
#     && curl -sS https://getcomposer.org/installer | php \
#     && mv composer.phar /usr/local/bin/composer

# #Xdebug
# COPY xdebug.ini /etc/php/7.2/mods-available/xdebug.ini
# RUN sed -i "s/xdebug\.remote_host=.*/xdebug\.remote_host="$(/sbin/ip route|awk '/default/ { print $3 }')"/" /etc/php/7.2/mods-available/xdebug.ini \
#     && sed -i "s|zend_extension=xdebug.so|zend_extension=$(find / -iname xdebug.so 2>&1 | grep -v 'Permission denied' | tail -1)|" /etc/php/7.2/mods-available/xdebug.ini
# ENV PHP_IDE_CONFIG=serverName=application

# COPY ./start-container /usr/local/bin/start-container
# RUN chmod +x /usr/local/bin/start-container

# #Gestione utente
# #https://docs.docker.com/engine/reference/builder/#user
# RUN mkdir /home/utente \
#     && groupadd -g $HOST_GID utente \
#     && useradd -u $HOST_UID --gid $HOST_GID -d /home/utente -s /bin/bash utente \
#     && usermod -a -G www-data utente \
#     && chown utente /home/utente \
#     && echo 'alias ll="ls -alFh"' >> /home/utente/.bashrc

# WORKDIR /var/www/app

# #Faccio girare php-fpm come `utente`
# RUN sed -i "s/user = www-data/user = utente/" /etc/php/7.2/fpm/pool.d/www.conf && \
#     sed -i "s/group = www-data/group = utente/" /etc/php/7.2/fpm/pool.d/www.conf

# CMD ["start-container"]
