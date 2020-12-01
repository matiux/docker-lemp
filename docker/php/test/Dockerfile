FROM matiux/php:8.0.0-fpm-alpine3.12-dev

USER root

 COPY conf/xdebug-3-starter.sh /usr/local/bin/xdebug-starter
 RUN chmod +x /usr/local/bin/xdebug-starter
 RUN /usr/local/bin/xdebug-starter

USER utente