#!/bin/bash

set -eu

if [ -z ${FTP_VOLUME:-} ]; then
	export "FTP_VOLUME=/var/ftp"
	mkdir -p $FTP_VOLUME
fi

# For anonymous FTP, need the user to have a valid home directory (which is NOT owned or writable by the user "ftp").
usermod -d $FTP_VOLUME ftp
chown root.root $FTP_VOLUME

# Remove write permission from group and others
chmod og-w $FTP_VOLUME

exec "$@"
