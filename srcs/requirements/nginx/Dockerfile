FROM alpine:3.22

# download nginx's source code from git repository
ADD "https://github.com/nginx/nginx.git" /build/nginx

# install prerequisites to build nginx binary and delete cache
# --update-cache flag fetches the current package index before adding the package
# --virtual make groups to easily delete them later
RUN apk add --update-cache --virtual .build-deps \
	gcc \
	libc-dev \
	make \
	openssl-dev \
	pcre2-dev \
	zlib-dev \
 	&& rm -rf /var/cache/apk/*

WORKDIR /build/nginx

# overwrite its original configuration file
COPY conf/nginx.conf conf/nginx.conf

RUN ./auto/configure --with-http_ssl_module \
 && make -j $(nproc) && make install \
 && apk del .build-deps

# nginx will be installed into /usr/local/nginx directory
WORKDIR /usr/local/nginx
RUN rm -rf /build/nginx

# requirements for nginx runtime
RUN apk add --update-cache \
	pcre2 \
	openssl

COPY tools/docker-entrypoint.sh /usr/local/bin/

EXPOSE 443

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "sbin/nginx", "-g", "daemon off;"]
