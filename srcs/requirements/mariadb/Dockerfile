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
COPY ./conf/mariadb.sources /etc/apt/sources.list.d/

# add our user and group first before installing mariadb-server that automatically creates mysql user 
# to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql \
 && useradd -r -g mysql mysql --home-dir /var/lib/mysql

# Install MariaDB 11.4 from the MariaDB repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
 && rm -rf /var/lib/apt/lists/* \
# purge and re-create /var/lib/mysql with appropriate ownership (mariadb installation automatically creates and install db into /var/lib/mysql)
 && rm -rf /var/lib/mysql \
 && mkdir -p /var/lib/mysql /run/mysqld \
 && chown -R mysql:mysql /var/lib/mysql /run/mysqld \
# ensure that /run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
 && chmod 1777 /run/mysqld

COPY tools/docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3306

# ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "mariadbd", "--user=mysql", "--datadir=/var/lib/mysql" ]