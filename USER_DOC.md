## Services are provided by the stack ##
This project provides a complete web hosting stack using Docker containers.\
Each service is isolated and performs a specific role within the system.

- **Nginx**
	- It handles HTTPS connections and forwards requests to the backend servises
- **MariaDB**
	- Database for WordPress, including users, posts and settings.
- **PHP-FPM** 
	- Executies php scripts forwarded from Nginx as a backend. 
- **WordPress** 
	- Provides the main website and contents management system (CMS) with PHP-FPM.
- **Redis**
	- Improves performance by cashing WordPress objects in memory.
- **Adminer**
	- Offers a web-based interface for managing the MariaDB database.
- **Vsftpd**
	- Allows file downloads via file transfer protocol (FTP).
- **Static site (Gunicorn + Flask)**
	- Serves a simple static website with a backend.
- **Uptime-kuma**
	- Monitors service availability and uptime.

---

## How to start and stop the project ##

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

---

## Access to the website and the administration panel ##

### Web Services ###
Type the following URLs into a web browser to access the services:

- **WordPress** - https://tmitsuya.42.fr
- **WordPress admin panel** - https://tmitsuya.42.fr/wp-admin
- **Static site** - https://tmitsuya.42.fr/static-site

### Database Administration ###
- **Adminer** - https://tmitsuya.42.fr/adminer

### Monitoring ###
- **Uptime-kuma** - https://monitor.tmitsuya.42.fr

### FTP a=Access ###

To access the **vsftp server** pointing to the WordPress volume, use an FTP client such as [FileZilla](https://filezilla-project.org/). \
Connect to the server:
- Host: tmitsuya.42.fr
- Port: 21

> **Note:** the FTP server operates in anonymous-only mode, and all write and upload permissions are disabled for security reasons.

---

## Where to locate and manage credentials ##


---

## How to check that the services are running correctly ##

---

This file must explain, in clear and simple terms, how an end user or administrator can:
◦ Understand what services are provided by the stack.
◦ Start and stop the project.
◦ Access the website and the administration panel.
◦ Locate and manage credentials.
◦ Check that the services are running correctly.