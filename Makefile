NAME= inception

DB_LAB_COMPOSE=testdatabases/docker-compose.yml

db-lab-up:
	docker compose -f $(DB_LAB_COMPOSE) up -d

db-lab-bench:
	chmod +x testdatabases/scripts/bench.sh
	./testdatabases/scripts/bench.sh

db-lab-down:
	docker compose -f $(DB_LAB_COMPOSE) down
