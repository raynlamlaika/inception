#!/bin/bash

# here the  setup that we will need to set up the database and run it when the container starts is defined.

# first we will start the mariadb service temporarily to initialize the database and create the necessary user and database if they do not exist.

if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
fi

if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
else
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-wordpress}
fi

MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wordpress}

# service mariadb start is used to start the mariadb service in the container. This allows us to run the mysql commands to set up the database and user.
service mariadb start
echo "Waiting for MariaDB to start..."
# until mysqladmin -u root ping > /dev/null 2>&1 || mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} ping > /dev/null 2>&1; do
DATABASE_READY=false

for i in {1..30}; do 
    if mysqladmin -u root ping > /dev/null 2>&1 || mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} ping > /dev/null 2>&1; then 
        DATABASE_READY=true
        break
    fi
        echo "[$i/30] ... waiting for mariadb"
        sleep 2
        if [ $i -eq 30 ]; then
            echo "MariaDB is not ready after 30 attempts. Exiting."
            exit 1
        fi
done





























if mysql -u root -e "SELECT 1;" > /dev/null 2>&1; then
    # if the root user does not have a password, we will set it up and create the database and user.
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" #  the % is equivalent to localhost, it means that the user can connect from any host. This is necessary because the wordpress container will be connecting to the mariadb container from a different host.
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;" # the flush privileges command is used to reload the privileges from the grant tables in the mysql database. This is necessary after making changes to the user accounts or permissions to ensure that the changes take effect immediately.
else
    # if the root user already has a password, we will use it to create the database and user.
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi



mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown # after setting up the database and user, we will shut down the mariadb service to start it again in the foreground.

# finally, we will start the mariadb service in the foreground so that it continues to run and accept connections from other containers.
echo "MariaDB is ready. Starting in foreground..."
exec mariadbd-safe --bind-address=0.0.0.0 #---port 1210 # the exec command is used to replace the current shell process with the mariadbd-safe process. This allows the container to run the mariadb service in the foreground and keep it running as long as the container is running. The --bind-address=







