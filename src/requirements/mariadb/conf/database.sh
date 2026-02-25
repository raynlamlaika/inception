#!/bin/bash

service mariadb start

SQLDB_PASS=$(cat /run/secrets/db_password)

sleep 5
mariadb -uroot << STOP
CREATE DATABASE IF NOT EXISTS \`${SQLDB_NAME}\`;
CREATE USER IF NOT EXISTS '${SQLDB_USER}'@'%' IDENTIFIED BY '${SQLDB_PASS}';
GRANT ALL PRIVILEGES ON \`${SQLDB_NAME}\`.* TO '${SQLDB_USER}'@'%';
FLUSH PRIVILEGES;
STOP

mysqladmin -u root shutdown

exec mysqld_safe --bind-address=0.0.0.0