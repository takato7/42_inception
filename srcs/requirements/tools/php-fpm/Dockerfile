FROM alpine:3.21

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
	# for Adminer
	--with-zlib \
 && make -j $(nproc) && make install \
 && make clean

# php-fpm will be installed into /usr/local directory after installation
ENV INSTALL_DIR=/usr/local

# inject my php-fpm configuration file
# set daemonize = no and include=/usr/local/etc/php-fpm.d/*.conf (for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf")
COPY conf/php-fpm.conf $INSTALL_DIR/etc/
# to prevent Nginx from passing requests to the PHP-FPM backend if the file does not exist, allowing us to prevent arbitrarily script injection. 
# (fix this by setting the cgi.fix_pathinfo directive to 0 within our php.ini file.)
COPY conf/php.ini $INSTALL_DIR/php/
# set "clear_env = no" to all environment variables available to PHP code; via getenv(), $_ENV and $_SERVER that are to be used in wp-config-docker.php
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
