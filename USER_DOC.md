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

## Where to locate and manage credentials ##

Credentials in this project are stored using Docker secrets, placed inside a `secrets/` directory at the project root.

You need to prepare the following files, each containing the password for the respective service:
- **Wordpress**
    - `wp_user_password.txt`
    - `wp_admin_password.txt`
- **MariaDB**
    - `db_password.txt`
    - `db_root_password.txt`

---

## Access to the website and the administration panel ##
Check if the services are running correctly by attempting to connect.

### WordPress site ###
Type the following URLs into a web browser:
- **URL** - https://tmitsuya.42.fr
> Try posting a comment using the **Hello world!** link.

### Static site ###
Type the following URLs into a web browser:
- **URL** - https://tmitsuya.42.fr/static-site

### WordPress Administration Panel ###
Type the following URL into a web browser:
- **URL** - https://tmitsuya.42.fr/wp-admin

Login with the credentials below:
**General user**
- **Username** - `tmitsuya` (defined as `WP_USER_NAME` in `.env`)
- **Password** - see `wp_user_password.txt`
**As an admin user**
- **Username** - `wp_controller` (defined as `WP_ADMIN_NAME` in `.env`)
- **Password** - see `wp_admin_password.txt`

> To enable the **Redis Object Cache**, login as an admin for the first time.
> Go to the Plugin panel, select **Redis Object Cache**, click the **Enable Object Cache** button.

### Database Administration - Adminer ###
Type the following URL into a web browser:
- **URL** - https://tmitsuya.42.fr/adminer

Login with the credentials below:
- **Server** - `mariadb` (defined as `WP_DB_HOST` in `.env`)
- **Username** - `wp_user` (defined as `MARIADB_USER` in `.env`)
- **Password** - see `db_password.txt`
- **Database** - `wordpress` (defined as `MARIADB_DATABASE` in `.env`)

### Monitoring - Uptime-kuma ###
Type the following URL into a web browser:
- **URL** - https://monitor.tmitsuya.42.fr

> You need to create an account the first time you access the service.
> When setting up a new monitor for the other services, check the **Ignore TLS/SSL errors for HTTPS websites** because self-signed certificates are used.

### FTP Access ###
To access the **vsftp server** pointing to the WordPress volume, use an FTP client such as [FileZilla](https://filezilla-project.org/). Connect to the server:
- **Host** - tmitsuya.42.fr
- **Port** - 21

> **Note:** The FTP server operates in anonymous-only mode, and all write and upload permissions are disabled for security reasons.
