all: setup up

setup:
	@sudo echo "Setting hosts..."
	@sudo chmod a+w /etc/hosts
	@sudo cat /etc/hosts | grep maalexan.42.fr || echo "127.0.0.1 maalexan.42.fr" >> /etc/hosts
	@sudo mkdir -p /home/maalexan/data/wp-pages
	@sudo mkdir -p /home/maalexan/data/wp-database
	@sudo mkdir -p /home/maalexan/data/adminer-volume
	@sudo mkdir -p /home/maalexan/data/minecraft-volume

up:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d

redis:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d redis

build-redis:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate redis

down-redis:
	sudo docker-compose -f ./srcs/docker-compose.yml down redis

adminer:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d adminer

build-adminer:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate adminer

down-adminer:
	sudo docker-compose -f ./srcs/docker-compose.yml down adminer

minecraft:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d minecraft

build-minecraft:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate minecraft

down-minecraft:
	sudo docker-compose -f ./srcs/docker-compose.yml down minecraft

site:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d site

build-site:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate site

down-site:
	sudo docker-compose -f ./srcs/docker-compose.yml down site

ftp:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d ftp

build-ftp:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate ftp

down-ftp:
	sudo docker-compose -f ./srcs/docker-compose.yml down ftp

nginx:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d nginx 

build-nginx:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate nginx

down-nginx:
	sudo docker-compose -f ./srcs/docker-compose.yml down nginx

mariadb:
	sudo mkdir -p /home/maalexan/data/wp-database
	sudo docker-compose -f ./srcs/docker-compose.yml up -d mariadb 

build-mariadb:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate mariadb

down-mariadb:
	sudo docker-compose -f ./srcs/docker-compose.yml down mariadb

wordpress:
	sudo mkdir -p /home/maalexan/data/wp-pages
	sudo docker-compose -f ./srcs/docker-compose.yml up -d wordpress 

build-wordpress:
	sudo docker-compose -f ./srcs/docker-compose.yml up -d --build --force-recreate wordpress

down-wordpress:
	sudo docker-compose -f ./srcs/docker-compose.yml down wordpress

down:
	sudo docker-compose -f ./srcs/docker-compose.yml down

clean:
	@sudo rm -rf /home/maalexan
	@sudo docker-compose -f ./srcs/docker-compose.yml down -v --rmi all --remove-orphans

fclean: clean
	@sudo docker system prune --volumes --all --force

re: fclean all

.PHONY: all
