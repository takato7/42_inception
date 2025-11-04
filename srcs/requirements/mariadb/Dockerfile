FROM debian:bookworm

# RUN apt update && apt install -y \
#     software-properties-common \
#     devscripts

# https://mariadb.org/download/?t=repo-config&d=Debian+12+%22Bookworm%22&v=11.4&r_m=xtom_dus
# Commands to run to import the MariaDB repository key on my Debian system:
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
 && mkdir -p /etc/apt/keyrings \
 && curl -o /etc/apt/keyrings/mariadb-keyring.pgp \
    'https://mariadb.org/mariadb_release_signing_key.pgp'

# Once the key is imported, copy and paste the following into a file 
# under /etc/apt/sources.list.d (for instance /etc/apt/sources.list.d/mariadb.sources):
COPY conf/mariadb.sources /etc/apt/sources.list.d/

# add our user and group first before installing mariadb-server that seems to automatically create mysql user 
# to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql \
 && useradd -r -g mysql mysql
 	# --home-dir /var/lib/mysql

# Install MariaDB 11.4 from the MariaDB repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
 && rm -rf /var/lib/apt/lists/* \
# purge /var/lib/mysql because mariadb installation automatically creates and install db into /var/lib/mysql
# the directory where database should be set is created by docker compose when mounting it to a volume 
# and database will be installed later, if it has been not set up yet
 && rm -rf /var/lib/mysql \
# prepare a directory used for the socket and lock files
 && mkdir -p /run/mysqld \
 && chown -R mysql:mysql /run/mysqld \
# ensure that /run/mysqld is writable regardless of the UID our mysqld instance ends up having at runtime
 && chmod 1777 /run/mysqld \
# comment out a few problematic configuration values (bind-address should not be local)
 && find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log|user\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log|user\s)/#&/' \
# don't reverse lookup hostnames, they are usually another container
 && printf "[mariadb]\nhost-cache-size=0\nskip-name-resolve\n" > /etc/mysql/mariadb.conf.d/05-skipcache.cnf

COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY tools/healthcheck.sh /usr/local/bin/

EXPOSE 3306

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "mariadbd" ]
