FROM matiux/php:5.3.29-apache2.4.10-dev

# USER root

COPY conf/xdebug-starter.sh /usr/local/bin/xdebug-starter
RUN chmod +x /usr/local/bin/xdebug-starter
RUN /usr/local/bin/xdebug-starter

# USER utente