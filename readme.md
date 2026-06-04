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
wordpress depand on the database MARIADB so after the varibles setup next is  the loop waiting for the mariadb server
```
for i in {1..30}; do 
    if mariadb -h mariadb -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1" >/dev/null 2>&1; then break
    fi
        echo "[$i/30] ... waiting for mariadb"
        sleep 2
done 
```

after that we set up:
  check the downloading of the wp core into working directory:`/var/www/html`
  net is creating the database connection :
  Creates wp-config.php with database connection settings.
  --dbname: DB name
  --dbuser: DB username
  --dbpass: DB password
  --dbhost="mariadb": hostname of your MariaDB service on the Docker network (service name).
  next change the owner ship for the files recsvly for the folder: chown -R www-data:www-data /var/www/html
  next is the chmoud for the access



---

### Networking, Dockerfiles, and Compose

Every dockerfile start with the base in my case i user ``Debain:bullseye`` it used as a template for our contrainer
that it will hold up the packages that  we need to install and copy into it the scripts that we need to run we cna also create from it 
some dependencies
common keyword used:
  FROM:
  RUN:
  CMD:
  EXPOSE:
  ENTRYPOINT:
  ENV:
  WORKDIR:
  ARG:
  VOLUME:

  ## Type of volumes
  named volumes:
  anonymose volumes:
  ## Type of binds
  Bind Mounts:
  tmpfs Mounts:



---

### Secrets and How to Run

Secrets are expected as files referenced by `docker-compose.yml` and are mounted in containers at `/run/secrets/<name>`. Create the secret files on the host before `docker-compose up` (or change the compose paths to match where your secrets live).

---

### Kubernetes (notes)

This project can be adapted to Kubernetes. Use Secrets for credentials and configure Services/Ingress for nginx and WordPress.
