## Services are provided by the stack ##
This project provides a complete web hosting stack using Docker containers.
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

---

## How to access the website and the administration panel ##
### URLs for the websites ###
- **WordPress** - https://tmitsuya.42.fr
- **Adminer** - https://tmitsuya.42.fr/adminer
- **Static site** - https://tmitsuya.42.fr/static-site
- **Uptime-kuma** - https://monitor.tmitsuya.42.fr


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