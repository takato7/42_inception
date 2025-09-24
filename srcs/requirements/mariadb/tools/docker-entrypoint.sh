#!bin/bash

user=mysql
datadir=/var/lib/mysql
database_already_exist='false'

function basic_single_escape ()
{
    # The quoting on this sed command is a bit complex.  Single-quoted strings
    # don't allow *any* escape mechanism, so they cannot contain a single
    # quote.  The string sed gets (as argv[1]) is:  s/\(['\]\)/\\\1/g
    #
    # Inside a character class, \ and ' are not special, so the ['\] character
    # class is balanced and contains two characters.
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

function docker_setup_env()
{
    mariadb_root_password="$(basic_single_escape "$(cat "$MARIADB_ROOT_PASSWORD_FILE")")"
    mariadb_password="$(basig_single_escape "$(cat "$MARIADB_PASSWORD_FILE")")"
    if [ -d "$datadir/mysql" ]; then
        database_already_exist='true'
    fi

}

function docker_exec_client() {
	# args sent in can override this db, since they will be later in the command
	if [ -n "$MYSQL_DATABASE" ]; then
		set -- --database="$MYSQL_DATABASE" "$@"
	fi
	mariadb --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" "$@"
}


function docker_cleanup_env()
{
    unset 'MARIADB_ROOT_PASSWORD'
    unset 'MARIADB_PASSWORD'
}

function docker_secure_install()
{
    echo "Securing system users (equivalent to running mysql_secure_installation)"
    # set a password for root accounts.
    root_localhost_pass="SET PASSWORD FOR 'root'@'localhost'= PASSWORD('${mariadb_root_password}');"
    remove_remote_root="DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    remove_anonymous_users="DELETE FROM mysql.global_priv WHERE User='';"
    remove_test_database="DROP DATABASE IF EXISTS test;"
    remove_privileges_on_test_database="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"


}

docker_setup_env
if [ $database_already_exist != 'true']
    mariadb-install-db --datadir=$datadir --
    docker_secure_install
exec "$@"
