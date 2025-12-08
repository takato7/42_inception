#!/bin/bash

set -eu

srcdir=/usr/src

if [ -z ${UPTIME_KUMA_VOLUME:-} ]; then
	export "UPTIME_KUMA_VOLUME=/var/uptime-kuma"
	mkdir -p $UPTIME_KUMA_VOLUME
fi

# move the source files to mounted volume
cp -R "$srcdir/"* "$UPTIME_KUMA_VOLUME"
cd "$UPTIME_KUMA_VOLUME"

exec "$@"