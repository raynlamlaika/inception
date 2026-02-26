FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y php7.4-fpm php7.4-mysql curl mariadb-client

RUN rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


COPY tools/setup.sh /setwp.sh

RUN chmod +x /setwp.sh

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# ENTRYPOINT && CMD
ENTRYPOINT ["/setwp.sh"]