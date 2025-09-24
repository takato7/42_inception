SRCS_DIR	:=	srcs

YAML		:=	docker-compose.yml

PROJECT		:=	inception

IMAGES		:=	nginx

COMPOSE		:=	docker compose

FLAGS		:=	-d --build

up:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML) up $(FLAGS)

down:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML) down -v

rmi-all: down
	docker rmi $(PROJECT)-nginx
	docker rmi $(PROJECT)-wordpress
	docker rmi $(PROJECT)-mariadb

config:
	docker compose -f $(SRCS_DIR)/$(YAML) config

.PHONY: up down config