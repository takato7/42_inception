#!/bin/bash

# Check if wordpress source files already exit, if not copy them from image and configure its configuration file

# set -e: exit on any error, -u: error on unset variables, -o pipefail: pipeline fails if any command fails
set -euo pipefail

user="www-data"
group="www-data"
wp_source=/usr/src/wordpress

if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
    echo "WordPress not found in $PWD - copying now"

    # using "tar . | tar" to copy files to keep correct owners, permissions, and avoids overwrite issues.
    sourceTarArgs=(
        --create
        --file -
        --directory "$wp_source"
        --owner "$user" --group "$group"
    )
    targetTarArgs=(
        --extract
        --file -
    )
    tar "${sourceTarArgs[@]}" . | tar "${targetTarArgs[@]}"

	# using "awk" to replace all instances of "put your unique phrase here" with a properly unique string
    SALTS=$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/)
    awk -v salts="$SALTS" '
    BEGIN { replaced = 0 }
    /put your unique phrase here/ {
        if (!replaced) {
        print salts
        replaced = 1
        }
        next
    }
    { print }
    ' "wp-config-docker.php" > wp-config.php
    chown "$user:$group" wp-config.php
fi

exec "$@"