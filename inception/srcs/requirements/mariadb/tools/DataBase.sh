#!/bin/bash
set -e

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wordpress}

service mariadb start

echo "Waiting for MariaDB..."

until mariadb-admin ping --silent; do
    sleep 1
done

echo "MariaDB started"

mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

exec mysqld_safe --bind-address=0.0.0.0
