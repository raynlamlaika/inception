FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server


COPY tools/DataBase.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306
# see the defrent betweeen entrypoint and  cmd
ENTRYPOINT ["/usr/local/bin/setup.sh"]

