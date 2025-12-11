*This project has been created as part of the 42 curriculum by tmitsuya*

---

## Description ##
This project aims to broaden knowledge of system administration by using Docker. It involves virtualizing multiple services using Docker images and running them inside a personal virtual machine.

---

## Project Description ##

**Main Design for This Project**
This project sets up a **LEMP stack infrastructure** that hosts a WordPress website. Additional services useful for operating a website are included. Each service runs in its own **containerized environment**, isolated by Docker. **Docker Compose** is used to manage and orchestrate all services together. 
### Implemented Services ###
- **Nginx** - HTTP server for handling web requests
- **MariaDB** - Database for WordPress
- **PHP-FPM** - PHP FastCGI Process Manager for executing WordPress
- **WordPress** - PHP-based CMS for the website
- **Redis** - In-memory database used as a cache for WordPress
- **Adminer** - PHP-based database management tool
- **Vsftpd** - Linux-based FTP server
- **Gunicorn + Flask** - WSGI server and framework serving a static website
- **Uptime-kuma** - Monitoring tool for the web services

***Why Docker instead of Virtual Machine***
Docker virtualizes at the **application layer**, while virtual machines virtualize at the **kernel layer**, including the entire operating system. Because of this, virtual machines require significantly more system resources, while Docker containers are lightweight and start much faster. As Services don't require a full OS for each instance, making Docker a suitable choice.

***Docker Compose Simplification***
Docker Compose simplifies orchestration by:
- Starting and stopping services together
- Managing networks for inter-container communication
- Creating persistent volumes

***Docker Network for Services Communication***
When Docker Engine starts for the first time, it provides a single built-in network called the "default bridge" network, which is isolated from the host system.
This project uses a user-defined network, whick allows:
- Containers to communicate using container names
- Separattion of groups of containers through custom networks

***Docker Volumes and Bind Mounts***
Docker volumes are created and managed by Docker and preserved even when containers are removed. You can also bind a host directory to a path inside a container, called the "bind mount". 
This project uses Docker volumes for services requiring data persistence and mounts them to appropriate directories on the host.

***Docker Secrets over Environment Variables***
Credentials in this project are stored using Docker secrets, placed inside a secrets/ directory at the project root.
This is more secure than storing credentials in a .env file as environment variables because:
- Secrets are encrypted during transit and at rest in a Docker swarm
- Secrets are not committed to version control accidentally
- They are not exposed as plain-text environment variables

---

## Instruction ##
Build all Docker images from the Dockerfiles and start all containers:
```sh
make build
make up
```
Or simply run:

```sh
make
```
Stop containers and remove them (but keep volumes):
```sh
make down
```
List all containers, images, networks and volumes:
```sh
make ls
```

---

## Resources ##
- **Docker & Docker Compose**
	- [Docker](https://docs.docker.com/get-started/docker-overview/)
	- [Docker Compose](https://docs.docker.com/compose/intro/compose-application-model/)
	- [Docker Network](https://docs.docker.com/engine/network/)
	- [Docker Volumes](https://docs.docker.com/engine/storage/volumes/)
	- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/#intermediate-example-use-secrets-with-a-nginx-service)
- **Nginx**
	- [Source code & build instructions](https://github.com/nginx/nginx)
	- [Configuring HTTPS](https://nginx.org/en/docs/http/configuring_https_servers.html)
	- [Configuring HTTPS admin-guide](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/)
	- [FastCGI configuration](http://nginx.org/en/docs/beginners_guide.html#fastcgi)
	- [Location blocks](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)
	- [Reverse proxy configuration](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
- **MariaDB**
	- [Installation](https://mariadb.org/download/?d=Debian+12+%22Bookworm%22&v=11.4&r_m=xtom_dus&t=repo-config)
	- [WordPress database setup](https://developer.wordpress.org/advanced-administration/before-install/creating-database/)
	- [Secure installation](https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-secure-installation)
	- [Official Docker image](https://github.com/MariaDB/mariadb-docker/blob/cdffb7d2fd712249f3f386497117825be6442afa/11.4/Dockerfile)
- **PHP-FPM**
	- [PHP-FPM installation](https://www.php.net/manual/en/install.fpm.install.php)
	- [Using PHP-FPM with Nginx](https://www.php.net/manual/en/install.unix.nginx.php)
	- [Official Docker image](https://github.com/docker-library/php/blob/d059b359952036541c8cc8a6070c1d47d7f86caf/8.3/alpine3.21/fpm/Dockerfile)
- **WordPress**
	- [wp-config.php reference](https://developer.wordpress.org/advanced-administration/wordpress/wp-config/)
	- [Running WordPress behind a proxy](https://developer.wordpress.org/advanced-administration/server/web-server/nginx/)
	- [Redis cache configuration](https://github.com/rhubarbgroup/redis-cache/#configuration)
	- [Installing WP-CLI](https://make.wordpress.org/cli/handbook/guides/installing/)
	- [Official Docker image](https://github.com/docker-library/wordpress/blob/f143dd4b24dcefc3b633e4a10ed3534d92b91c23/latest/php8.3/fpm-alpine/wp-config-docker.php)
- **Redis**
	- [Redis installation](https://github.com/redis/redis?tab=readme-ov-file#build-and-run-redis-with-all-data-structures---debian-11-bullseye--12-bookworm)
	- [Redis cache configuration](https://redis.io/docs/latest/operate/oss_and_stack/management/config/#configuring-redis-as-a-cache)
- **Adminer**
	- [Adminer homepage](https://www.adminer.org/en/)
- **Vsftpd**
	- [About vsftpd](https://security.appspot.com/vsftpd.html)
	- [Configuration](https://security.appspot.com/vsftpd/vsftpd_conf.html)
- **Gunicorn / Flask**
	- [Flask Documentation](https://flask.palletsprojects.com/en/stable/)
	- [Flask behind a proxy](https://flask.palletsprojects.com/en/stable/deploying/proxy_fix/)
	- [Running Gunicorn](https://flask.palletsprojects.com/en/stable/deploying/gunicorn/)
- **Uptime-kuma**
	- [Uptime-kuma GitHub](https://github.com/louislam/uptime-kuma)
	- [Using nvm in Docker](https://github.com/nvm-sh/nvm#installing-in-docker)
	- [pm2 documentation](https://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/)

---