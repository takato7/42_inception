SRCS_DIR		:=	srcs

VOLUME_ROOT		:=	/home/tmitsuya/data
VOLUME_DIRS		:=	$(VOLUME_ROOT)/wordpress \
					$(VOLUME_ROOT)/mariadb \
					$(VOLUME_ROOT)/adminer \
					$(VOLUME_ROOT)/uptime-kuma

YAML_FILE		:=	docker-compose.yml

DOCKER			:=	docker
COMPOSE			:=	docker compose

UPFLAGS			:=	-d --remove-orphans
DOWNFLAGS		:=	-v

PHP_BASE_IMAGE	:=	php-fpm
PHP_BASE_DIR	:=	$(SRCS_DIR)/requirements/tools/php-fpm/
PHP_BASE_NAME	:=	$(PHP_BASE_IMAGE)-base
IMAGE_VIRSION	:=	1.0.0

all: up

build-base:
	$(DOCKER) build $(PHP_BASE_DIR) -t $(PHP_BASE_NAME):$(IMAGE_VIRSION)

build: build-base
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) build

up: build | $(VOLUME_DIRS)
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) up $(UPFLAGS)

$(VOLUME_DIRS):
	mkdir -p $@

down:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) down $(DOWNFLAGS)

ps:
	@echo "\n============ Docker containers ============"
	$(DOCKER) ps -a

config:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) config

logs:
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

ls: ps
	@echo "\n============ Docker images ============"
	@$(DOCKER) images
	@echo "\n============ Docker volumes ============"
	@$(DOCKER) volume ls
	@echo "\n============ Docker network ============"
	@$(DOCKER) network ls

rmc:
	@$(DOCKER) stop $$($(DOCKER) ps -qa)
	@$(DOCKER) rm $$($(DOCKER) ps -qa)

rmi:
	@$(DOCKER) rmi -f $$($(DOCKER) images -qa)

rmv:
	@$(DOCKER) volume rm $$($(DOCKER) volume ls -q)

rmn:
	@$(DOCKER) network rm $$($(DOCKER) network ls -q) 2>/dev/null

prune:
	@$(DOCKER) image prune -f
	@$(DOCKER) container prune -f
	@$(DOCKER) system prune -f

clean: rmc rmn rmv prune

fclean: clean rmi

.PHONY: all build build-base up down ps config log exec run ls rmc rmi rmv rmn prune clean fclean
