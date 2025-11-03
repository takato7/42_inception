SRCS_DIR	:=	srcs

VOLUME_ROOT	:=	/home/tmitsuya/data
VOLUME_DIRS	:=	$(VOLUME_ROOT)/wordpress $(VOLUME_ROOT)/mariadb

YAML_FILE	:=	docker-compose.yml

COMPOSE		:=	docker compose
UPFLAGS		:=	-d --build
DOWNFLAGS	:=	-v

up: | $(VOLUME_DIRS)
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) up $(UPFLAGS)

$(VOLUME_DIRS):
	mkdir -p $@

down:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) down $(DOWNFLAGS)

config:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) config

log:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) logs

exec:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML_FILE) exec -it 

.PHONY: up down config
