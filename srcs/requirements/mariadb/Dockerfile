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

# Install MariaDB 11.4 from the MariaDB repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
 && rm -rf /var/lib/apt/lists/*

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# create directory for the database (volume), socket and lock file
# ensure that /run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
# RUN groupadd -f -r mysql \
#  && useradd -r -g mysql mysql --home-dir /var/lib/mysql \
RUN mkdir -p /var/lib/mysql /run/mysqld \
 && chown -R mysql:mysql /run/mysqld \
 && chmod 1777 /run/mysqld

# install a database to the volume directory (if it already exists, mariadb-upgrade is run instead)
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

CMD [ "mariadbd", "--user=mysql", "--datadir=/var/lib/mysql" ]