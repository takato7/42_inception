#!/bin/bash

# Check if wordpress source files already exit, if not, copy them from the source directory and configure its configuration file

# set -e: exit on any error, -u: error on unset variables, -o pipefail: pipeline fails if any command fails
set -euo pipefail

user="www-data"
group="www-data"
wp_source="/usr/src/wordpress"

if [ -z $WP_VOLUME ]; then
	export "WP_VOLUME=/var/www/html"
	mkdir -p $WP_VOLUME
fi

if [ ! -e "${WP_VOLUME}/index.php" ] && [ ! -e "${WP_VOLUME}/wp-includes/version.php" ]; then
    echo "WordPress not found in $WP_VOLUME - copying now"

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
		--directory "$WP_VOLUME"
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
    ' "${WP_VOLUME}/wp-config-docker.php" > "${WP_VOLUME}/wp-config.php"
    echo "Complete the copying process"

	# create the wordpress database and tables by wp-cli tool
	# https://developer.wordpress.org/cli/commands/

	echo "Install WordPress tables and create admin user"
	# https://developer.wordpress.org/cli/commands/core/install/
	wp core install --allow-root --path=$WP_VOLUME \
			--url=$WP_SITEURL --title=$WP_SITE_TITLE \
			--admin_user=$WP_ADMIN_NAME --admin_email=$WP_ADMIN_EMAIL \
			--skip-email \
			--prompt=admin_password < $WP_ADMIN_PASSWORD_FILE \
			--quiet

	echo "create a new editor user"
	# https://developer.wordpress.org/cli/commands/user/create/
	wp user create --allow-root --path=$WP_VOLUME \
			$WP_USER_NAME $WP_USER_EMAIL \
			--role=$WP_USER_ROLE \
			--user_pass="$(< "$WP_USER_PASSWORD_FILE")" \
			--porcelain

fi

# change the ownership of the volume directory after the creation and the mount by the docker compose
chown -R "$user:$group" $WP_VOLUME

exec "$@"
