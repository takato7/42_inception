*This project has been created as part of the 42 curriculum by tmitsuya*

## Description ##
clearly presents the project, including its goal and a brief overview.

This project aims to broaden knowledge of system administration by using Docker.
Virtualize several Docker images, creating them in a new personal virtual machine.

## Instruction ##
containing any relevant information about compilation, installation, and/or execution.

containers use 

Just run the following command at the root of your project:
```sh
make
```


## Resources ##
listing classic references related to the topic (documentation, articles, tutorials, etc.), as well as a description of how AI was used — specifying for which tasks and which parts of the project


## Project description ##
This project is designed to set up LEMP stack infrastructure hosting a web site using WordPress for basics. On top of it, it sets up additional services that are useful on web applications. Each service is containalized by using Docker.
Docker isolates its environment each service is running, and Docker Compose is used to manage to control their processes, create or delete network and volumes.

The implemented services are:
Basics
Nginx: a http server for handling http requests
MariaDB: a database for WordPress
PHP-FPM: PHP Fast CGI protocol manager for handling WordPress

Additionals
Redis: in-memory database as an aside cache for WordPress
Adminer: php application for database management of WordPress
Vsftpd: a linux-based FTP server
Gunicorn / Flask: a WSGI server and framework for a static web site
Uptime-kuma: a monitoring tool for the web applications

Why Docker not Virtual Machine
While Docker virtualizes services at an application layer withing an OS, virtual machine does at kernel layer as well. Because of this virtual machine takes much more resources to setup its virtual environment than Docker. It do not need to virtualize the whole operating system for each services this time and Docker Compose make it easy for all services to communicate with each other by creating with a network and volumes for them and orchestrating their processes.

Secrets vs Environment Variables


explain the use of Docker and the sources included in the project. It must indicate the main design choices, as well as a comparison between:
Virtual Machines vs Docker: 


Docker Network vs Host Network


Docker network is created  containers


Docker Volumes vs Bind Mounts
Docker volumes are created by Docker engine and persist even after thier containers are deleted. On the other hand, bind mounts is just mounted a directory path on the host machine to one within a container. This project creates Docker volumes for the necessary services and mounted corresponding directories on the host machine to each volumes.



Bonus
Redis
	changes on the configuration file from default
		- commented out "bind 127.0.0.1 -::1"
		- protected-mode yes --> no
		- maxmemory 10mb
		- maxmemory-policy allkeys-lfu
	refference
		- configuration file of redis https://redis.io/docs/latest/operate/oss_and_stack/management/config/

