SRCS_DIR	:=	srcs

YAML		:=	docker-compose.yml

PROJECT		:=	inception

IMAGES		:=	nginx

COMPOSE		:=	docker compose

FLAGS		:=	-d

up:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML) up $(FLAGS)

down:
	$(COMPOSE) -f $(SRCS_DIR)/$(YAML) down

rmi:
	docker rmi $(PROJECT)-$(IMAGES)

.PHONY: up down