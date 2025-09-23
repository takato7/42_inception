FROM alpine:3.21

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
COPY ./conf/nginx.conf conf/nginx.conf

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

# generate private key and certificate for TLS protocol
RUN mkdir -p conf/ssl \
 && openssl req -x509 -newkey rsa:2048 -nodes \
 -keyout conf/ssl/nginx_key.pem \
 -out conf/ssl/nginx_self_cert.pem \
 -subj "/C=NL/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

EXPOSE 443

CMD [ "sbin/nginx", "-g", "daemon off;"]