#!/bin/bash

if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/wp_admin_password ]; then
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
fi

if [ -f /run/secrets/wp_password ]; then
    WP_USER_PASSWORD=$(cat /run/secrets/wp_password)
fi

#waiting for the database to be ready before starting wordpress setup
for i in {1..30}; do 
    if mariadb -h mariadb -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1" >/dev/null 2>&1; then break
    fi
        echo "[$i/30] ... waiting for mariadb"
        sleep 2
done
echo "mariadb is ready!"

# if the wp-config.php file does not exist, we will set up wordpress. This is done to ensure that we only set up wordpress once and not every time the container starts.
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core --allow-root download --force
    wp config --allow-root create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost="mariadb"
    chown -R www-data:www-data /var/www/html
    chmod 755 /var/www/html
fi

if ! wp core --allow-root is-installed; then
    wp core --allow-root install --title="${WP_TITLE}" --url="${DOMAIN_NAME}" --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email
    wp user --allow-root create "${WP_USER}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASSWORD}" --role=author
fi

wp option update home "${DOMAIN_NAME}" --allow-root
wp option update siteurl "${DOMAIN_NAME}" --allow-root

if [ "${DOMAIN_NAME}" != "https://127.0.0.1:8443/" ]; then
    wp option update home "https://127.0.0.1:8443/" --allow-root
    wp option update siteurl "https://127.0.0.1:8443/" --allow-root
fi


# sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's|listen = .*|listen = 0.0.0.0:9000|' $(find /etc/php -path "*/fpm/pool.d/www.conf")

mkdir -p /run/php #check why


echo "wordpress is ready!"

exec php-fpm8.2 -F
