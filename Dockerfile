ARG VERSION=15.0.2

FROM alpine:latest as downloader
ARG VERSION

RUN wget https://github.com/Dolibarr/dolibarr/archive/refs/tags/${VERSION}.zip -O dolibarr.zip
RUN unzip dolibarr.zip -d /tmp/
RUN rm dolibarr.zip

FROM php:8-apache
ARG VERSION

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libicu-dev \
        libzip-dev \
        libpq-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd intl zip calendar pgsql

COPY --from=downloader /tmp/dolibarr-${VERSION}/htdocs /var/www/html/
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
