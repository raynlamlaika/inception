#!/bin/bash

SQLDB_PASS=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

for i in {1..30}; do 
    if mariadb -h mariadb -u $SQLDB_USER -p$SQLDB_PASS -e "SELECT 1" >/dev/null 2>&1; then break
    fi
        echo "[$i/30] ... waiting for mariadb"
        sleep 2
done
echo "mariaddb is ready!"

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core --allow-root download --force
    wp config --allow-root create --dbname=${SQLDB_NAME} --dbuser=${SQLDB_USER} --dbpass=${SQLDB_PASS} --dbhost="mariadb"
    wp core --allow-root install --title=${WP_TITLE} --url=${DOMAIN_NAME} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}  --skip-email
    wp user --allow-root create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author
    chown -R www-data:www-data /var/www/html
    chmod 755 /var/www/html
fi

sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

echo "wordpress is ready!"

exec php-fpm8.2 -F