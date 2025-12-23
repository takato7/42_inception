## How to set up the environment from scratch ##

- **Docker & Docker Compose**
	- [Install Docker & Docker Compose](https://docs.docker.com/engine/install/debian/#install-using-the-repository)

- **Nginx**
	- **Dockerfile**
		- Install Nginx with the Openssl module to handle HTTPS connections.
			- [Source code & build instructions](https://github.com/nginx/nginx).
	- **Configuration**
		- Create and configure the nginx.conf
			- [Configuring HTTPS](https://nginx.org/en/docs/http/configuring_https_servers.html)
			- [Configuring HTTPS admin-guide](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/)
			- [FastCGI configuration](http://nginx.org/en/docs/beginners_guide.html#fastcgi)
			- [Location blocks](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)
			- [Reverse proxy configuration](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
- **MariaDB**
	- **Dockerfile**
		- Install mariadb-server and create appropriate system user.
	- **Configuration**
		- Prepare a mariadb.source file for the key to installing mariadb-server from the official repository.
		- Comment out "bind-address" from the 50-server.cnf/my.cnf file (default is localhost) in order to allow connections from any address.
			- these files are located just as references only; the actual configuration is applied directly in the Dockerfile.
	- **Database installation**:
		- Reinitialize the system database with remote root access disabled and with anonymous users removed.
		- Create WordPress database using mariadb-client.
		- These steps are executed in the docker-entrypoint script after the container creation.
- **PHP-FPM**
	- **Dockerfile**
		- Install PHP with PHP-FPM, MySQL support.
		- This image is used as a base image for PHP-FPM, WordPress and Adminer containers.
	- **Configuration**
		- Configure: 
			- php-fpm.conf
				- Set "daemonize = no"
				- Set "include=/usr/local/etc/php-fpm.d/\*.conf" (The upstream default incorrectly sets this to "include=NONE/etc/php-fpm.d/*.conf")
			- php.ini
				- Set "cgi.fix_pathinfo=0" to prevent Nginx from passing requests to the PHP-FPM backend if the file does not exist, allowing us to prevent arbitrarily script injection.
			- www.conf
				- Set "clear_env = no" to all environment variables available to PHP code; via getenv(), $_ENV and $_SERVER that are to be used in wp-config-docker.php	
- **WordPress**
	- **Dockerfile**
		- Copy PHP_FPM binaries from the base image.
		- Download WordPress source files and WP-CLI.
	- **Configuration**
		- Configure: 
			- wp-config-docker.php
				- [wp-config.php reference](https://developer.wordpress.org/advanced-administration/wordpress/wp-config/)
				- [Running WordPress behind a proxy](https://developer.wordpress.org/advanced-administration/server/web-server/nginx/)
				- [Redis cache configuration](https://github.com/rhubarbgroup/redis-cache/#configuration)
	- **Datatable installation**
		- Create WordPress database tables. 
		- Create an admin user in the database by WP-CLI.
		- Install Redis Object Cache plugin by WP-CLI.

- **Redis**
	- **Dockerfile**
		- Download and build source files for Redis.
	- **Configuration**
		- Configure: 
			- redis.conf
				- Comment out "bind 127.0.0.1 -::1" to listen on all interfaces.
				- Overwrite protected-mode "yes" to "no" to allow connections from other containers.
				- Configure memory limits:
					- "maxmemory 10mb"
					- "maxmemory-policy allkeys-lfu", all the keys will be evicted using an approximated LRU algorithm as long as we hit the 10 megabyte memory limit.
					- [Redis cache configuration](https://redis.io/docs/latest/operate/oss_and_stack/management/config/#configuring-redis-as-a-cache)


- **Adminer**
	- **Dockerfile**
		- Copy PHP-FPM binaries from the base image.
		- Download the adminer.php file.

- **Vsftpd**
	- **Dockerfile**
		- Build vsftpd from source following the INSTALL file. 
			- [About vsftpd](https://security.appspot.com/vsftpd.html)
	- **Configuration**
		- vsftpd.conf
			- Set "listen=YES" to run vsftpd in standalone (no-daemonized) mode
			- Set "anonymous_enable=YES" to allow access by an anonymous user "ftp" to the server without password
			- Configure "pasv_min_port" / "pasv_max_port" for passive mode, a range of ports to be opened for data transfer. 
				- Ensure the firewall allows this port range.
				- [Configuration](https://security.appspot.com/vsftpd/vsftpd_conf.html)

- **Gunicorn/Flask (Static Site)**
	- **Dockerfile**
		- Install python3 and dependencies such as Flask, Gunicorn.
		- Run Gunicorn with the appropriate bind address.
	- **Application Structure**
		tools/
		├── app.py
		├── requirements.txt
		│   ├── Flask
		│   ├── python-dotenv
		│   ├── watchdog
		│   ├── greenlet
		│   └── gunicorn
		└── templates/
			└── index.html

- **Uptime-Kuma**
	- **Dockerfile**
		- Install Node.js for the runtime using NVM (node version manager).
		- Install pm2
		- Clone the Uptime-kuma repository and run server.js.

---

## How to build and launch the project using the Makefile and Docker Compose ##

Using the Makefile:
```sh
make build
make up
```
Or simply run:
```sh
make
```
Using Docker Copmose:
```sh
docker build srcs/requirements/tools/php-fpm -t php-fpm-base:1.0.0
docker compose -f srcs/docker-compose.yml build
docker compose -f srcs/docker-compose.yml up -d
```
Note: The PHP-FPM base image must be built first.

---

## The commands to manage the containers, images, networks and volumes ##

List all containers, images, networks and volumes:
```sh
make ls
```
Start containers
```sh
make up
```
Stop containers and remove them (but keep volumes):
```sh
make down
```
or
```sh
make rmc
```

Remove images:
```sh
make rmi
```
Remove volumes:
```sh
make rmv
```
Remove networks:
```sh
make rmn
```
Remove unused system files:
```sh
make prune
```
Remove everything:
```sh
make clean
```

To execute a command in a specific running container, run the following command and then specify a service name listed in docker-compose.yml file and the command:
```sh
make exec
```
To run a container and execute a command from an specific image, run the following command and then specify a service name listed in docker-compose.yml file and the command:
```sh
make run
```

---

## Where the project data is stored and how it persists ##

Project data is persisted using Docker volumes, which is stored within a directory on the Docker host and mounted into the container. A path on the host machine is mounted the volume so that you can see the data from the path.
- Host path: /host/tmitsuya/data 
- Data for WordPress, MariaDB, Adminer, Uptime-kuma is stored in this path.

---

