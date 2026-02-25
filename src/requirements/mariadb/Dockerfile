FROM debian:bullseye-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld /run/secrets && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /run/secrets

COPY conf/database.sh /database.sh
RUN chmod +x ./database.sh

ENTRYPOINT ["/database.sh"]