# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maalexan <maalexan@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/11 07:54:59 by maalexan          #+#    #+#              #
#    Updated: 2025/04/11 08:29:23 by maalexan         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

LOGIN								:= maalexan
DATA_DIR						:= /home/$(LOGIN)/data
COMPOSE_ENV					:= LOGIN=$(LOGIN) DATA_DIR=$(DATA_DIR) UID=$$(id -u) GID=$$(id -g)
DOCKER_COMPOSE_YML	:= ./srcs/docker-compose.yml
SERVICES						:= nginx wordpress mariadb adminer redis site

all: permission setup up

setup:
	@echo "Setting up hosts and data directories..."
	@if [ "$$(whoami)" != "$(LOGIN)" ]; then \
		echo "Creating volume directories as root..."; \
		sudo mkdir -p $(DATA_DIR)/wp-database; \
		sudo mkdir -p $(DATA_DIR)/wp-pages; \
		sudo mkdir -p $(DATA_DIR)/adminer-volume; \
		sudo chown -R $$(whoami):$$(whoami) /home/$(LOGIN); \
	fi
	@grep -q "$(LOGIN).42.fr" /etc/hosts || echo "127.0.0.1 $(LOGIN).42.fr" | sudo tee -a /etc/hosts > /dev/null

up:
	$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) up -d

down:
	$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) down

permission:
	@printf "Checking Docker permissions... "
	@docker info > /dev/null 2>&1 || (\
		printf "❌\n"; \
		echo "Docker requires elevated permissions"; \
		echo "Try: sudo usermod -aG docker $$(whoami) && newgrp docker"; \
		false)
	@echo "✅"


define service_rules
$(1):
	$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) up -d $(1)

build-$(1):
	$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate $(1)

stop-$(1):
	$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) stop $(1)

remove-$(1):
	$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) rm -sfv $(1)

endef

$(foreach svc,$(SERVICES),$(eval $(call service_rules,$(svc))))

clean:
	@if [ "$(FORCE)" != "true" ] && [ "$$(whoami)" != "user42" ]; then \
		echo "You should only run this command inside the VM as user42."; \
		echo "To override, run: make $(MAKECMDGOALS) FORCE=true"; \
		exit 1; \
	fi
	@sudo rm -rf $(DATA_DIR)/wp-pages $(DATA_DIR)/wp-database $(DATA_DIR)/adminer-volume
	@sudo rmdir $(DATA_DIR) || echo "$(DATA_DIR) should be empty but isn't"
	@$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) down -v --rmi all --remove-orphans

fclean: clean
	@echo "Removing all containers and images for services: $(SERVICES)"
	@$(COMPOSE_ENV) docker-compose -f $(DOCKER_COMPOSE_YML) rm -sfv $(SERVICES)

re: fclean all

nuke: clean
	@$(COMPOSE_ENV) docker system prune --volumes --all --force

env:
	@echo "Generating .env file with placeholder passwords..."
	@echo "WP_DATABASE_HOST=mariadb\nWP_DATABASE_NAME=wordpress\nWP_DATABASE_USER=wp_user\nWP_DATABASE_ROOT=root\nWP_URL=http://localhost\nWP_TITLE=My Awesome Site\nWP_ADMIN_USER=toptier\nWP_ADMIN_EMAIL=toptier@example.com\nWP_USER=changer\nWP_USER_EMAIL=changer@example.com\nHEALTH_USER=healthchecker\nREDIS_HOST=redis\nREDIS_PORT=6379\nFTP_USER=ftpuser\nFTP_PATH=/var/www/wordpress\nWP_DATABASE_PASSWORD=CHANGE_ME_DB_PASS\nWP_DATABASE_ROOT_PASSWORD=CHANGE_ME_ROOT_PASS\nWP_ADMIN_PASSWORD=CHANGE_ME_ADMIN_PASS\nWP_USER_PASSWORD=CHANGE_ME_USER_PASS\nFTP_PASSWORD=CHANGE_ME_FTP_PASS\nHEALTH_PASS=CHANGE_ME_HEALTH_PASS" > srcs/.env
	@echo ".env generated, you can run this command to be able to visualize the containers"
	@echo "alias dps=\"docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}'\""

.PHONY: all setup up down clean fclean nuke re permission env \
	$(SERVICES) \
	$(addprefix build-,$(SERVICES)) \
	$(addprefix stop-,$(SERVICES)) \
	$(addprefix remove-,$(SERVICES)) 

