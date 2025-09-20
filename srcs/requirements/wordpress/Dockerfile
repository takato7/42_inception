FROM alpine:3.21 AS php-fpm

ENV PHP_URL="https://www.php.net/distributions/php-8.3.25.tar.xz"
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

RUN mkdir -p $SRC_DIR \
 && cd $SRC_DIR \
 && curl -fsSL -o php.tar.xz $PHP_URL \
 && tar -Jxf php.tar.xz --strip-components=1 \
 && ./configure \
    --disable-phpdbg \
    --enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --with-openssl \
    --with-curl \
 && make && make install \
 && make clean

# php-fpm will be installed into /usr/local directory after installation
ENV INSTALL_DIR=/usr/local

# obtain and move configuration files to their correct locations
RUN cd $SRC_DIR \
 && cp php.ini-development $INSTALL_DIR/php/php.ini \
 && mv $INSTALL_DIR/etc/php-fpm.d/www.conf.default $INSTALL_DIR/etc/php-fpm.d/www.conf

# inject my php-fpm configuration file
# set daemonize = no and include=/usr/local/etc/php-fpm.d/*.conf (for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf")
COPY ./conf/php-fpm.conf /usr/local/etc/

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
    redis

# ensure www-data user exists
# 82 is the standard uid/gid for "www-data" in Alpine
# https://git.alpinelinux.org/aports/tree/main/nginx/nginx.pre-install?h=3.14-stable

WORKDIR $WP_PATH
RUN	adduser -u 82 -D -S -G www-data www-data
 && chown www-data:www-data $WP_PATH

# # matching compatibility with PHP, mariaDB version (https://make.wordpress.org/hosting/handbook/server-environment/)
ENV WP_VERSION="6.8.2"
ENV WP_URL="https://wordpress.org/wordpress-$WP_VERSION.tar.gz"

RUN curl -fsSL -o wordpress.tar.gz $WP_URL \
 && tar -zxf wordpress.tar.gz --strip-components=1 \
 && mv wp-config-sample.php wp-config.php \
 && rm -fr wordpress.tar.gz

EXPOSE 9000

CMD [ "/usr/local/sbin/php-fpm" ]
