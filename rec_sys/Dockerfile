FROM mariadb:11

ENV MARIADB_DATABASE=spotfy_DB
ENV MARIADB_USER=user


COPY conf.sh /docker-entrypoint-initdb.d/conf.sh
COPY spotify_millsongdata.csv /docker-entrypoint-initdb.d/spotify_millsongdata.csv

RUN chmod +x /docker-entrypoint-initdb.d/conf.sh && \
    chmod 644 /docker-entrypoint-initdb.d/spotify_millsongdata.csv

EXPOSE 3306