#!/usr/bin/env bash

set -e

XDEBUG_HOST="$HOST_IP"

# try to get the ip of the host from ns host.docker.internal
if [[ -z "$XDEBUG_HOST" ]]; then
  XDEBUG_HOST=$(getent hosts host.docker.internal | awk '{ print $1 }')
fi

# try to get the linux host ip
if [[ -z "$XDEBUG_HOST" || "$XDEBUG_HOST" == "127.0.0.1" ]]; then
  XDEBUG_HOST=$(ip route | awk 'NR==1 {print $3}')
fi

# use the ip alias loopback
# if [ -z "$XDEBUG_HOST" ]; then
#     XDEBUG_HOST=`10.254.254.254`
# fi

#Ubuntu / Debian PHP < 8
#sed -i "s/xdebug\.remote_host=.*/xdebug\.remote_host=${XDEBUG_HOST}/" /etc/php/8.0/mods-available/xdebug.ini

#Ubuntu / Debian PHP >= 8
#sed -i "s/xdebug\.client_host=.*/xdebug\.client_host=${XDEBUG_HOST}/" /etc/php/8.0/mods-available/xdebug.ini

#Alpine < PHP 8
#sed -i "s/xdebug\.remote_host=.*/xdebug\.remote_host=${XDEBUG_HOST}/" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

#Alpine >= PHP 8
sed -i "s/xdebug\.client_host=.*/xdebug\.client_host=${XDEBUG_HOST}/" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini