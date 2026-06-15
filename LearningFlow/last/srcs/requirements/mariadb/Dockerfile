FROM debian:bookworm


RUN  apt-get update && apt-get install -y mariadb-server mariadb-client 

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]

