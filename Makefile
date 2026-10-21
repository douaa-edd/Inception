NAME= inception
COMPOSE_FILE= ./srcs/docker-compose.yml

all : up

up :
	@mkdir -p /home/deddaidi/data/portainer
	@mkdir -p /home/deddaidi/data/mariadb
	@mkdir -p /home/deddaidi/data/wordpress
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

clean:
	docker compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans

fclean: clean
	@sudo rm -rf /home/deddaidi/data/portainer
	@sudo rm -rf /home/deddaidi/data/mariadb/*
	@sudo rm -rf /home/deddaidi/data/wordpress/*
	docker system prune -af

re: fclean all

.PHONY: all up down clean fclean re
