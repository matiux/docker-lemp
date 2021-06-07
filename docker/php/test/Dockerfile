FROM matiux/php:8.0-fpm-debian-buster-dev

USER root

COPY --chown=www-data:www-data conf/xdebug-starter.sh /usr/local/bin/xdebug-starter
RUN chmod +x /usr/local/bin/xdebug-starter
RUN /usr/local/bin/xdebug-starter

#USER utente
USER www-data