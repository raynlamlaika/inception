#!/bin/bash

# here the build of the scripte for the setup of the database By maria




# chown -R mysql:mysql /var/lib/mysql
# to start data base in the bg 
service mariadb start

# wait for data basee
# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "Database not initialized. This might be the problem."
# fi
# mysqladmin : do ping for the data serv is runing or not how ??
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 2
done





#  need to create data base and the user
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"

#set the root passord
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"


mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# 7. Start MariaDB in the foreground (this keeps the container alive)
# We use 'exec' so that signals (like stop) are handled correctly
echo "MariaDB is ready. Starting in foreground..."
exec mysqld_safe