# FROM debian:bookworm

# RUN apt-get update 
# RUN apt-get install -y php7.4-fpm php7.4-mysql curl mariadb-client
FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get install -y php8.2-fpm php8.2-mysql
# RUN rm -rf /var/lib/apt/lists/*

#those every dependency is needed to run wordpress and to connect it to the database
# php7.4-fpm is the FastCGI Process Manager for PHP, which allows us to run PHP applications efficiently.
# php7.4-mysql is the PHP extension for MySQL, which allows PHP to interact with MySQL databases.
# curl is a command-line tool for transferring data with URLs, which is used to download the WP-CLI tool.
# mariadb-client is the client software for MariaDB, which allows us to interact with the database from the command line


# this command is used to remove the cached package lists from the apt-get update command, which helps to reduce the size of the Docker image.
# the package storage size in range of 100-200MB, so removing the cached package lists can help to reduce the overall size of the image and improve performance when running the container.


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
# this command is used to download the WP-CLI tool, which is a command-line interface for managing WordPress installations. 
# The command uses curl to download the WP-CLI phar file from the specified URL, then it makes the file executable with chmod +x, and finally it

COPY tools/setup.sh /setwp.sh


RUN chmod +x /setwp.sh

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

EXPOSE 80
# this command is used to specify that the container will listen on port 80 at runtime,
ENTRYPOINT ["/setwp.sh"]


