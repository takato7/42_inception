#!/bin/bash

# Check if adminer.php files already exit, if not, copy them from the source directory

# set -e: exit on any error, -u: error on unset variables, -o pipefail: pipeline fails if any command fails
set -euo pipefail

user="www-data"
group="www-data"
admnr_source="/usr/src/adminer"
admnr_file="adminer.php"

if [ -z ${ADMINER_VOLUME:-} ]; then
	export "ADMINER_VOLUME=/var/www/html"
	mkdir -p $ADMINER_VOLUME
fi

if [ ! -e "${ADMINER_VOLUME}/${admnr_file}" ]; then
    echo "Adminer not found in $ADMINER_VOLUME - copying now"
	cp "$admnr_source"/"$admnr_file" "$ADMINER_VOLUME"
    echo "Complete the copying process"
fi

# change the ownership of the volume directory after the creation and the mount by the docker compose
chown -R "$user:$group" $ADMINER_VOLUME

exec "$@"
