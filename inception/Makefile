
WP_VOLUME = /home/rlamlaik/data/wp_data
MARIADB_VOLUME = /home/rlamlaik/data/mariadb_data


DK=docker 
DKC=docker-compose


all: build run

build: volumes
	@echo "Building all services..."
	$(DKC) -f srcs/docker-compose.yml build

volumes: remove_volumes
	@echo "Creating volumes..."
	sudo mkdir -p $(WP_VOLUME)
	sudo mkdir -p $(MARIADB_VOLUME)
	sudo chmod -R 777 $(WP_VOLUME) $(MARIADB_VOLUME)

run: 
	@echo "Running all services in background..."
	$(DKC) -f srcs/docker-compose.yml up -d

clean: down_containers remove_volumes
	@echo "Cleaning up all services..."


remove_volumes:
	$(DK) system prune -af --volumes
	sudo rm  -rf $(WP_VOLUME)/*
	sudo rm -rf $(MARIADB_VOLUME)/*

down_containers:
	$(DKC) -f srcs/docker-compose.yml down

