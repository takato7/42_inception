#!/bin/bash

mariadb -uroot -hlocalhost --protocol=socket --database=mysql -e "SELECT 1" > /dev/null 2>&1
# mariadb -u $DB_USER --database=wordpress -e 'SHOW TABLES;' --password="$(< "$WP_DB_PASSWORD_FILE")" \