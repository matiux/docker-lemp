FROM matiux/php:7.3.5-fpm-alpine3.9-dev

USER root

COPY conf/xdebug-starter.sh /usr/local/bin/xdebug-starter
RUN chmod +x /usr/local/bin/xdebug-starter
RUN /usr/local/bin/xdebug-starter

USER utente