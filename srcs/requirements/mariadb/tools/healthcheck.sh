#!/bin/bash

mariadb -u "$MARIADB_USER" \
		--database="$MARIADB_DATABASE" \
		--password="$(< "$MARIADB_PASSWORD_FILE")" \
		-e "SELECT 1" > /dev/null 2>&1
