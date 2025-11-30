FROM alpine:3.21

# copy php-fpm files from previous build stage
COPY --from=php-fpm-base:1.0.0 /usr/local /usr/local

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
COPY --chown=www-data:www-data conf/wp-config-docker.php /usr/src/wordpress
COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY tools/healthcheck.sh /usr/local/bin/

EXPOSE 9000

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "php-fpm" ]
