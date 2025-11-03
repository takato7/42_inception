#!/bin/sh

set -eu

keydir="/usr/local/nginx/conf/ssl"
private_key="${keydir}/nginx_key.pem"
certificate="${keydir}/nginx_self_cert.pem"

function generate_ssl_keys()
{
	mkdir -p "$keydir"
	openssl req \
			-x509 \
			-newkey rsa:2048 \
			-nodes \
			-keyout "$private_key" \
 			-out "$certificate" \
 			-subj "/C=NL/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"
}

if [ ! -d $keydir ]; then
	generate_ssl_keys
fi

exec "$@"
