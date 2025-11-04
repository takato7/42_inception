#!/bin/bash

set -eu

function docker_setup_query()
{
	# Read from the environment variables or the secrets files for password
	user="$MARIADB_USER"
	database="$MARIADB_DATABASE"
	root_password="$(< "$MARIADB_ROOT_PASSWORD_FILE")"
	password="$(< "$MARIADB_PASSWORD_FILE")"
	
	# Securing system user
	# https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-secure-installation
	# (test database is skipped during the installation)
	set_root_localhost_pass="SET PASSWORD FOR 'root'@'localhost'= PASSWORD( '${root_password}' );"
	remove_remote_root="DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
	remove_anonymous_users="DELETE FROM mysql.global_priv WHERE User='';"

	# Create mysql@localhost for 'mysql' system user
	create_mysql="CREATE USER mysql@localhost IDENTIFIED VIA unix_socket;"
	mysql_grants="GRANT ALL PRIVILEGES ON *.* TO mysql@localhost;"

	# Create the database and the user by using the mariadb client
	# https://developer.wordpress.org/advanced-administration/before-install/creating-database/
	create_data_base="CREATE DATABASE IF NOT EXISTS $database;"
	create_user="CREATE USER '$user'@'%' IDENTIFIED BY '$password';"
	user_grants="GRANT ALL PRIVILEGES ON ${database}.* TO '$user'@'%';"

	# Reloading the privilege tables will ensure that all changes made
	reload_privilege_tables="FLUSH PRIVILEGES;"
}

function docker_install_db()
{
	# echo "Create directories for the database, the socket and lock files"
	# mkdir -p "$datadir" "/run/mysqld"
	# chown -R "mysql:mysql" "$datadir" "/run/mysqld"
	# ensure that /run/mysqld (used for socket and lock files) is writable 
	# regardless of the UID our mysqld instance ends up having at runtime
	# chmod 1777 "/run/mysqld"
	
	echo "Start the mariadb install process"
	mariadb-install-db --datadir=$MARIADB_VOLUME --skip-test-db
	echo "End of the install process"

	chown -R "mysql:mysql" $MARIADB_VOLUME
}

function docker_setup_db()
{
	# temporarily run the mariadb server in the background
	echo "Starting temporary mariadb server in the background"
	mariadbd --user=mysql --datadir="$MARIADB_VOLUME" &

	# PID of the last background command, e.g. mariadb daemon
	declare -g MARIADB_PID
	MARIADB_PID=$!

	echo "Waiting for server startup"
	local i
	for i in {30..0}; do
		if mariadb -uroot -hlocalhost --protocol=socket --database=mysql \
			-e "SELECT 1" > /dev/null 2>&1; then
			break
		fi
		sleep 1
	done
	if [ "$i" = 0 ]; then
		echo "Unable to start server."
		exit 1
	fi

	# tell docker_process_sql to not use MARIADB_ROOT_PASSWORD since it is just now being set
	mariadb -uroot -hlocalhost --protocol=socket --database=mysql <<-EOSQL
		-- setting root password and system user (equivalent to running mysql_secure_installation)
		${set_root_localhost_pass}
		${remove_remote_root}
		${remove_anonymous_users}
		${create_mysql}
		${mysql_grants}
		-- end of setting system users, rest of init now...

		-- create users/databases
		${create_data_base}
		${create_user}
		${user_grants}

		${reload_privilege_tables}
	EOSQL

	# stop the server and wait it
	echo "Stopping temporary mariadb server"
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
}


# define database directory if it's not been set
if [ -z $MARIADB_VOLUME ]; then
	export "MARIADB_VOLUME=/var/lib/mysql"
	mkdir -p $MARIADB_VOLUME
fi

# Install a database if it's not been set up yet
if [ ! -d "${MARIADB_VOLUME}/mysql" ]; then
	echo "initialize MariaDB"
	docker_setup_query
	docker_install_db
	docker_setup_db
	echo "Ready to run the server"
else
	# Even if the database already exists, still need to change the ownership of the newly created directory used for the database
	chown -R "mysql:mysql" $MARIADB_VOLUME
fi

if [ "$1" = "mariadbd" ]; then
	# run the daemon as 'mysql' system user
	exec "$@" --user=mysql --datadir="$MARIADB_VOLUME"
else
	exec "$@"
fi
