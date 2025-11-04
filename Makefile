SRCS_DIR	:=	srcs

VOLUME_ROOT	:=	/home/tmitsuya/data
VOLUME_DIRS	:=	$(VOLUME_ROOT)/wordpress $(VOLUME_ROOT)/mariadb

YAML_FILE	:=	docker-compose.yml

DOCKER		:=	docker
COMPOSE		:=	docker compose
UPFLAGS		:=	-d --build
DOWNFLAGS	:=	-v

up: | $(VOLUME_DIRS)
	$(DOCKER) image prune
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) up $(UPFLAGS)

$(VOLUME_DIRS):
	mkdir -p $@

down:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) down $(DOWNFLAGS)

ps:
	docker ps -a

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

.PHONY: up down config log exec
