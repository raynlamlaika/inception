NAME=inception

all: up

up:
	docker compose -f docker-compose.yml up --build -d

down:
	docker compose -f docker-compose.yml down

clean: down
	docker system prune -af --volumes

re: clean up
