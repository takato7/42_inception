#!/bin/bash

# set -e: exit on any error, -u: error on unset variables, -o pipefail: pipeline fails if any command fails
set -euo pipefail

tables_count=$(
	mariadb -u $WP_DB_USER -p $WP_DB_NAME -h $WP_DB_HOST \
	-e 'SHOW TABLES;' --password="$(< "$WP_DB_PASSWORD_FILE")" \
	| wc -l
	)

if [ "$tables_count" -le 1 ]; then
	exit 1
fi
