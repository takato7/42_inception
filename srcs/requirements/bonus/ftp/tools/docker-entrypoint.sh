#!/bin/bash

set -eu

if [ -z ${FTP_VOLUME:-} ]; then
	export "FTP_VOLUME=/var/ftp"
	mkdir -p $FTP_VOLUME
fi

usermod -d $FTP_VOLUME ftp

exec "$@"
