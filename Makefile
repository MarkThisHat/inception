# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maalexan <maalexan@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/11 07:54:59 by maalexan          #+#    #+#              #
#    Updated: 2025/04/11 08:05:12 by maalexan         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

USER				:= maalexan
DATA_DIR			:= /home/$(USER)/data
DOCKER_COMPOSE_YML	:= ./srcs/docker-compose.yml

all: permissions setup up

setup:
	@echo "Setting hosts..."
	@chmod a+w /etc/hosts
	@cat /etc/hosts  grep $(USER).42.fr || echo "127.0.0.1 $(USER).42.fr" >> /etc/hosts
	@mkdir -p $(DATA_DIR)/wp-pages
	@mkdir -p $(DATA_DIR)/wp-database
	@mkdir -p $(DATA_DIR)/adminer-volume
	@mkdir -p $(DATA_DIR)/minecraft-volume

up:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d

redis:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d redis

build-redis:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate redis

down-redis:
	docker-compose -f $(DOCKER_COMPOSE_YML) down redis

adminer:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d adminer

build-adminer:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate adminer

down-adminer:
	docker-compose -f $(DOCKER_COMPOSE_YML) down adminer

minecraft:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d minecraft

build-minecraft:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate minecraft

down-minecraft:
	docker-compose -f $(DOCKER_COMPOSE_YML) down minecraft

site:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d site

build-site:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate site

down-site:
	docker-compose -f $(DOCKER_COMPOSE_YML) down site

ftp:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d ftp

build-ftp:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate ftp

down-ftp:
	docker-compose -f $(DOCKER_COMPOSE_YML) down ftp

nginx:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d nginx 

build-nginx:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate nginx

down-nginx:
	docker-compose -f $(DOCKER_COMPOSE_YML) down nginx

mariadb:
	mkir -p $(DATA_DIR)/wp-database
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d mariadb 

build-mariadb:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate mariadb

down-mariadb:
	docker-compose -f $(DOCKER_COMPOSE_YML) down mariadb

wordpress:
	mkir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d wordpress 

build-wordpress:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate wordpress

down-wordpress:
	docker-compose -f $(DOCKER_COMPOSE_YML) down wordpress

down:
	docker-compose -f $(DOCKER_COMPOSE_YML) down

permission:
	@echo "Checking Docker permissions..."
	@docker info > /dev/null 2>&1 || (\
		echo "Docker requires elevated permissions"; \
		echo "Try: sudo usermod -aG docker $$(whoami) && newgrp docker"; \
		false)
	@echo "✅"

clean:
	@r -rf $(DATA_DIR)/wp-pages $(DATA_DIR)/wp-database $(DATA_DIR)/adminer-volume $(DATA_DIR)/minecraft-volume
	@docker-compose -f $(DOCKER_COMPOSE_YML) down -v --rmi all --remove-orphans

fclean: clean
	@docker system prune --volumes --all --force

re: fclean all

.PHONY: all
