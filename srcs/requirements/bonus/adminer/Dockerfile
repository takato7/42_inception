FROM alpine:3.21

# copy php-fpm files from previous build stage
COPY --from=php-fpm-base /usr/local /usr/local

# requirements for php runtime
RUN apk add --update-cache \
    libxml2 \
    sqlite-libs \
    curl \
    openssl \
    pcre \
    redis \
    tar \
    bash \
	# to healthcheck if the database are created, then ready 
	mariadb-client \
	php-zlib \
 && rm -rf /var/cache/apk/*

#  https://serverpilot.io/docs/guides/apps/adminer/
ENV ADMINER_VERSION="5.4.1"
ENV ADMINER_URL="https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php"

# download adminer.php file and create apropriate user / group 
RUN mkdir -p /usr/src/adminer \
 && cd /usr/src/adminer \
 && curl -fsSL -o adminer.php $ADMINER_URL \
 && adduser -u 82 -D -S -G www-data www-data \
 && chown -R www-data:www-data /usr/src/adminer

COPY tools/docker-entrypoint.sh /usr/local/bin/

EXPOSE 9000

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "php-fpm" ]
