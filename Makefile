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
DOCKER_COMPOSE_YML	:= ./srcs/docker-compose.yml
SERVICES						:= nginx wordpress mariadb adminer redis site

all: permission setup up

setup:
	@echo "Setting up hosts and data directories..."
#remove comment on final version @grep -q "$(LOGIN).42.fr" /etc/hosts || echo "127.0.0.1 $(LOGIN).42.fr" | sudo tee -a /etc/hosts > /dev/null

up:
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d

down:
	docker-compose -f $(DOCKER_COMPOSE_YML) down

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
	@mkdir -p $(DATA_DIR)/wp-pages
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d $(1)

build-$(1):
	LOGIN=$(LOGIN) docker-compose -f $(DOCKER_COMPOSE_YML) up -d --build --force-recreate $(1)

stop-$(1):
	docker-compose -f $(DOCKER_COMPOSE_YML) stop $(1)

remove-$(1):
	docker-compose -f $(DOCKER_COMPOSE_YML) rm -sfv $(1)

endef

$(foreach svc,$(SERVICES),$(eval $(call service_rules,$(svc))))

clean:
	@if [ "$(FORCE)" != "true" ] && [ "$$(whoami)" != "user42" ]; then \
		echo "You should only run this command inside the VM as user42."; \
		echo "To override, run: make $(MAKECMDGOALS) FORCE=true"; \
		exit 1; \
	fi
	@rm -rf $(DATA_DIR)/wp-pages $(DATA_DIR)/wp-database $(DATA_DIR)/adminer-volume $(DATA_DIR)/minecraft-volume
	@docker-compose -f $(DOCKER_COMPOSE_YML) down -v --rmi all --remove-orphans

fclean: clean
	@echo "Removing all containers and images for services: $(SERVICES)"
	@docker-compose -f $(DOCKER_COMPOSE_YML) rm -sfv $(SERVICES)

re: fclean all

nuke: clean
	@docker system prune --volumes --all --force


.PHONY: all setup up down clean fclean nuke re permission \
	$(SERVICES) \
	$(addprefix build-,$(SERVICES)) \
	$(addprefix stop-,$(SERVICES)) \
	$(addprefix remove-,$(SERVICES)) 
