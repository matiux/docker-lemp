Configurazioni docker / docker-compose
=====

## Immagini PHP:
* [PHP 8.0.* fpm - Debian Buster](docker/php/debian/buster/8.0-fpm)
* [PHP 8.0.1 fpm - Alpine 3.13](docker/php/alpine/3.13/8.0.1-fpm)
* [PHP 8.0.0 fpm - Alpine 3.12](docker/php/alpine/3.12/8.0.0-fpm)
* [PHP 7.4.2 fpm - Debian Buster](docker/php/debian/buster/7.4.2-fpm)
* [PHP 7.4.1 fpm - Alpine 3.11](docker/php/alpine/3.11/7.4.1-fpm)
* [PHP 7.3.6 fpm - Alpine 3.10](docker/php/alpine/3.10/7.3.6-fpm)
* [PHP 7.2.25 fpm - Alpine 3.10](docker/php/alpine/3.10/7.2.25-fpm)
* [PHP 7.1.30 fpm - Alpine 3.10](docker/php/alpine/3.10/7.1.30-fpm)
* [PHP 7.0.33 fpm - Alpine 3.7](docker/php/alpine/3.7/7.0.33-fpm)
* [PHP 5.6.40 fpm - Alpine 3.8](docker/php/alpine/3.8/5.6.40-fpm)
* [PHP 5.3.29 apache - Jessie](docker/php/debian/jessie/apache2.4.10/5.3.29)

[Hub pubblico](https://hub.docker.com/r/matiux/php/tags?page=1&ordering=last_updated)

## Istruzioni per generare le build 

#### Immagine base

```bash
docker build \
--build-arg GITHUB_TOKEN={github-token} \
#--build-arg BITBUCKET_CONSUMER_KEY={bitbucket-consumer-key} \
#--build-arg BITBUCKET_CONSUMER_SECRET={bitbucket-consumer-secret} \
-t matiux/php:8.0.1-fpm-alpine3.13-base .
```

#### Immagine dev
```bash
docker build \
-t matiux/php:8.0.1-fpm-alpine3.13-dev .
```

## Gestione tag

#### Tag di un'immagine dopo la build:

```bash
docker tag <id_immagine> \
matiux/php:8.0.1-fpm-alpine3.13-base
```

È anche possibile aggiungere più tag contemporaneamente:

```bash
docker build \
-t matiux/php:7.3.5-fpm-alpine3.9-base \
-t latest \
.
```

Se un'immagine ha più tag è possibile rimuovere un tag, in questo modo non verrà cancellata l'immagine ma solo il tag: 

```bash
docker rmi matiux/php:7.3.5-fpm-alpine3.9-base
```

#### Rinominare un tag: 

```bash
docker tag <id_immagine> <nuovo_tag>
docker tag b7bb3ad94649 matiux/php:7.3.5-fpm-alpine3.9-base
```

## Gestione hub:
* Login all'hub: `docker login`
* Push immagine sull'hub: `docker push matiux/php:8.0.1-fpm-alpine3.13-base`
* Pull immagine dall'hub: `docker pull matiux/php:8.0.1-fpm-alpine3.13-base`

## Gestione containers con docker-compose:

Il file [dc.sh](docker/dc.sh) è uno script che fa da wrapper a docker-compose semplificando l'utilizzo di alcuni comandi.

* `./dc`: Shortcut per `docker-compose ps`
* `./dc up`: Shortcut per `docker-compose up`. (Es. `./dc up -d`)
* `./dc enter`: Entra nel container php come utente `utente`
* `./dc enter-root`: Entra nel container php come utente `root`
* `./dc build php`: Esegue il build dell'immagine PHP
* `./dc down`: Smonta i servizi. (Es. `./dc down -v` per smontare anche i volumi)
* `./dc purge`: Smonta i servizi e cancella anche le immagini dal disco
* `./dc log`: Mette in ascolto sui log sei servizi
* `./dc *` (qualsiasi altro comando docker-compose)
* `./dc composer` Da accesso a composer fuori dal container

Nella macchina host è possibile creare alcuni alias per aggiungere ulteriore zucchero allo script:

```bash
#Docker
dstop() { docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq) }
alias denter="./dc enter"
alias dup="./dc up"
alias dupd="./dc up -d"
alias ddown="./dc down"
drmi() { docker rmi -f "$1" }
alias dsysp="docker system prune --all -f"
```

Vedere lo script per altre shortcuts.

## .gitignore:

Aggiungere queste righe al file `.gitignore` del progetto

```bash
docker/docker-compose.override.yml
docker/data/shell_history/.zsh_history
```

## Dockerizzare un progetto

* Copiare la cartella `docker` e il link simbolico `dc` nella root del progetto tranne il contenuto della cartela `docker/php`
* Copiare la cartella `docker/php/alpine/*/*/dev/conf` in `docker/php/conf`
* Create il file `docker/php/Dockerfile`
    * Personalizzare il `Dockerfile` specifico per il progetto.
* Copiare `docker/docker-compose.override.dist.yml` in `docker/docker-compose.override.yml`
    * Aggiungere `docker/docker-compose.override.yml` al `.gitignore` del progetto
    * Configurare le porte dei servizi. Il file `docker/docker-compose.override.yml` viene mergiato con il file `docker/docker-compose.yml`. La logica è di non versionare le porte dei servizi nel progetto. In questo modo ogni sviluppatore può configurarsi le porte come vuole anche nel caso in cui tenga due progetti in up con docker-compose; in questo modo le porte non vanno in conflitto.
* Personalizzare il file `docker/docker-compose.yml`
    * Nel servizio `web` in `docker/docker-compose.yml` settare il virtualhost per il framework utilizzato. Ci sono un po' di configurazioni in `docker/nginx` 
* Usare il comando `./dc` per file l'up dei servizi (Vedi istruzioni sopra)

Dentro la cartella `docker` c'è il file `docker-compose` e `docker-compose.`

## Xdebug:

Nelle immagini `dev` di PHP viene creato configurato Xdebug

* Alpine: `/usr/local/etc/php/conf.d/xdebug.ini`
* Ubuntu / Debian: `/etc/php/8.0/mods-available/xdebug.ini`

Nelle immagini PHP 8.* c'è Xdebug 3 che ha chiavi di configurazioni diverse

* [Prima di PHP 8](docker/php/alpine/3.11/7.4.1-fpm/dev/conf/xdebug.ini)
* [Da PHP 8](docker/php/alpine/3.12/8.0.0-fpm/dev/conf/xdebug.ini)

Nel docker file del progetto è necessario eseguire lo script [xdebug-starter.sh](docker/php/conf/xdebug-starter.sh) per settare l'ip dell'host.

```bash
COPY conf/xdebug-starter.sh /usr/local/bin/xdebug-starter
RUN chmod +x /usr/local/bin/xdebug-starter
RUN /usr/local/bin/xdebug-starter
```

Per l'utilizzo di Xdebug con PhpStorm le seguenti variabili vengono settare nel Dockerfile dev.

```bash
export PHP_IDE_CONFIG="serverName=application"
export XDEBUG_CONFIG="idekey=PHPSTORM"
```

#### Xdebug 3
[Opzioni rinominate](https://xdebug.org/docs/upgrade_guide)

## Comandi Docker utili:

* Pulizia totale: `docker system prune -af --volumes`
* Stop di tutti i container: `docker stop $(docker ps -aq)`
* Eliminazione di tutti i container stoppati: `docker rm -f $(docker ps -aq)`
* Eliminazione delle immagini: `docker rmi -f $(docker images -aq)`
* Informazioni sul volume: `docker volume inspect <id_volume>`
* Ottenere l'ip di un container: `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nomecontainer`

## Configurazioni PHPStorm

[Screenshots configurazioni](doc/xdebug/phpstorm)

## Miscellanea:

* Le cartelle `public` e `docker/php/test` servono a provare la configurazione `docker-compose` simulando una document root per il virtual host.
* Le immagini `dev` sono tutte configurate con oh-my-zsh, vim, xdebug e shell history. Il file viene creato in `docker/data/shell_history/.zsh_history` ma ovviamente non è versionato.
* Quando si usa un'immagine mysql / mariadb è possibile caricare un dump di un db (compresso o no) mettendolo nella cartella `docker/data/db`. Montando il volume nell'apposito entrypoint, in fase di up questo verrà caricato.

```bash
servicemysql:
    image: mysql:5.7.24
    volumes:
        - app_database:/var/lib/mysql
        - ./mysql/custom.cnf:/etc/mysql/conf.d/custom.cnf
        - ./data/db:/docker-entrypoint-initdb.d
```

* Dentro a ogni container è possibile raggiungere gli altri, usando come host il nome del servizio definito nel file `docker/docker-compose.yml`. Ad esempio l'host del db potrebbe essere `servicemysql`
* Collegarsi a mysql / mariadb dalla macchina host con il client `mycli`: `mycli -uroot -ppwd -h localhost -P3307`
* Collegarsi a mysql / mariadb dalla macchina host con il client `mysql`: `mycli -uroot -ppwd -h 127.0.0.1 -P3307`. (di default il client mysql usa Unix sockets invece di TCP. Quindi bisogna specificare l'IP per esteso e non usare "localhost" perchè lo traduce in unix socket invece di tcp/ip)
