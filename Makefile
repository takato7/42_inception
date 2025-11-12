SRCS_DIR		:=	srcs

VOLUME_ROOT		:=	/home/tmitsuya/data
VOLUME_DIRS		:=	$(VOLUME_ROOT)/wordpress $(VOLUME_ROOT)/mariadb

YAML_FILE		:=	docker-compose.yml

DOCKER			:=	docker
COMPOSE			:=	docker compose
UPFLAGS			:=	-d
DOWNFLAGS		:=	-v
PHP_BASE_IMAGE	:=	php-fpm
PHP_BASE_DIR	:=	$(SRCS_DIR)/requirements/tools/php-fpm/
PHP_BASE_NAME	:=	$(PHP_BASE_IMAGE)-base

all: up

build-base:
	$(DOCKER) build $(PHP_BASE_DIR) -t $(PHP_BASE_NAME)

build: build-base
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) build

up: build | $(VOLUME_DIRS)
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) up $(UPFLAGS)

$(VOLUME_DIRS):
	mkdir -p $@

down:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) down $(DOWNFLAGS)

ps:
	$(DOCKER) ps -a

config:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) config

log:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) logs

exec:
	@echo -n "Enter the name of service listed in compose.yml file to execute: "; \
	read serive_name; \
	echo -n "Enter the command: "; \
	read command; \
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) exec -it $$serive_name $$command

run:
	@echo -n "Enter the name of service listed in compose.yml file to execute: "; \
	read serive_name; \
	echo -n "Enter the command: "; \
	read command; \
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) run -it $$serive_name $$command

rm_container:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)


.PHONY: all build build-base up down ps config log exec run rm_container
