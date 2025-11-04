FROM alpine:3.21 AS php-fpm

ENV PHP_VERSION="8.3.25"
ENV PHP_URL="https://www.php.net/distributions/php-$PHP_VERSION.tar.xz"
ENV SRC_DIR=/usr/src

# install prerequisites to build php binary and delete cache
RUN apk add --update-cache --virtual .build-deps \
    autoconf \
    re2c \
    bison \
    gcc \
    libc-dev \
    make \
    pkgconf \
    libxml2-dev \
    sqlite-dev \
    dpkg-dev \
    tar \
    xz \
    curl-dev \
    curl \
    openssl-dev \
 && rm -rf /var/cache/apk/*

# obtain and unpack the PHP source to configure it with PHP-FPM and MySQL support
# https://www.php.net/manual/en/install.unix.nginx.php
RUN mkdir -p $SRC_DIR \
 && cd $SRC_DIR \
 && curl -fsSL -o php.tar.xz $PHP_URL \
 && tar -Jxf php.tar.xz --strip-components=1 \
 && ./configure \
    --with-mysqli \
    --enable-mysqlnd \
    --enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --with-openssl \
    --with-curl \
    --disable-cgi \
    --disable-phpdbg \
 && make -j $(nproc) && make install \
 && make clean

# php-fpm will be installed into /usr/local directory after installation
ENV INSTALL_DIR=/usr/local

# obtain and move configuration files to their correct locations
RUN cd $SRC_DIR \
 && cp php.ini-development $INSTALL_DIR/php/php.ini

# inject my php-fpm configuration file
# set daemonize = no and include=/usr/local/etc/php-fpm.d/*.conf (for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf")
COPY conf/php-fpm.conf $INSTALL_DIR/etc/
COPY conf/www.conf $INSTALL_DIR/etc/php-fpm.d/

# clean up unneccesarry files and strip unneeded symbols from binaries (to reduce image size)
RUN find -type f -name '*.a' -delete \
 && find /usr/local \
    -type f \
    -perm '/0111' \
    -exec sh -euxc '\ 
        strip --strip-all "$@" || : \
    ' -- '{}' + \
 && apk del .build-deps \
 && rm -rf $SRC_DIR

# second build for wordpress
FROM alpine:3.21

# copy php-fpm files from previous build stage
COPY --from=php-fpm /usr/local /usr/local

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
	# to healthcheck if WordPress database and tables are created, then ready 
	mariadb-client \
 && rm -rf /var/cache/apk/*

# check compatibility with PHP, mariaDB version (https://make.wordpress.org/hosting/handbook/server-environment/)
ENV WP_VERSION="6.8.2"
ENV WP_URL="https://wordpress.org/wordpress-$WP_VERSION.tar.gz"
ENV WP_CLI_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

# wordpress command line tool to install and create database for wordpress
# https://make.wordpress.org/cli/handbook/guides/installing/
RUN curl -O $WP_CLI_URL \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp \
# download wordpress files with its version fixed
 && mkdir -p /usr/src/wordpress \
 && cd /usr/src/wordpress \
 && curl -fsSL -o wordpress.tar.gz $WP_URL \
 && tar -zxf wordpress.tar.gz --strip-components=1 \
 && rm -fr wordpress.tar.gz

# add www-data:www-data user and group and change ownership of wordpress files
# 82 is the standard uid/gid for "www-data" in Alpine
# https://git.alpinelinux.org/aports/tree/main/nginx/nginx.pre-install?h=3.14-stable
RUN	adduser -u 82 -D -S -G www-data www-data \
 && chown -R www-data:www-data /usr/src/wordpress

# inject the tools to move wordpress files to root directory, if it does not exist
# and create and configure the wp-config.php file
COPY --chown=www-data:www-data tools/wp-config-docker.php /usr/src/wordpress
COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY tools/healthcheck.sh /usr/local/bin/

EXPOSE 9000

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "php-fpm" ]
