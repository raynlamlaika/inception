## INCEPTION

### Overview

This repository contains the basic services for a minimal WordPress stack: a MariaDB database, an Nginx web server, and WordPress (PHP). The following sections walk through each service and the configuration used to run them in containers.

---

### Database (MariaDB)

First we set up the MariaDB database. The typical installation command is:

```bash
apt-get update && apt-get install -y mariadb-server mariadb-client
```

- `mariadb-server`: Installs the MariaDB server daemon (usually `mysqld`). This stores databases and listens on port 3306 by default. Run the secure setup and create initial users/databases after installation.
- `mariadb-client`: Installs client tools such as the `mysql` CLI used to connect to a MariaDB/MySQL server. Use it from application containers or admin hosts as needed:

```bash
mysql -u root -p -h <db-host>
```

Startup script notes (what the container's init script reads):

- Read secrets / environment variables:

```bash
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wordpress}
```

- Required variables for the database: `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`.

- The script starts MariaDB in the background so it can run initialization SQL (create database, users, grant privileges):

```bash
service mariadb start
```

- The script waits for the server to accept connections before running SQL. Example wait loop used in the script:

```bash
until mysqladmin -u root ping >/dev/null 2>&1 || { [ -n "$MYSQL_ROOT_PASSWORD" ] && mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" ping >/dev/null 2>&1; }; do
  echo "Waiting for MariaDB..."
  sleep 2
done
```

---

### Nginx (load balancer / web server)

Nginx serves static files and forwards PHP requests to PHP-FPM (WordPress). The server listens on HTTPS:

```nginx
listen 443 ssl;
listen [::]:443 ssl;
```

- The first `listen` binds IPv4; the second enables IPv6.

Routing example (root location):

```nginx
location / {
    try_files $uri $uri/ /index.php?$args;
}
```

This checks for a static file or directory under the `root` (`/var/www/html`) and falls back to `index.php` (front controller) if none exists. This is the common pattern used by WordPress and many PHP frameworks.

---

### PHP / WordPress

WordPress runs under PHP-FPM. Nginx forwards `.php` requests to the PHP-FPM service (configured in `fastcgi_pass`). Ensure the PHP service is reachable (for example via Docker service name `wordpress` on port `9000`).

---

### Networking, Dockerfiles, and Compose

See the `docker-compose.yml` for service wiring (volumes, networks, and secrets). The compose file defines secrets that map host files into `/run/secrets` inside containers.

---

### Secrets and How to Run

Secrets are expected as files referenced by `docker-compose.yml` and are mounted in containers at `/run/secrets/<name>`. Create the secret files on the host before `docker-compose up` (or change the compose paths to match where your secrets live).

---

### Kubernetes (notes)

This project can be adapted to Kubernetes. Use Secrets for credentials and configure Services/Ingress for nginx and WordPress.
