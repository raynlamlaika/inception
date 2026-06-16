FROM debian:bookworm


RUN apt-get update && apt-get install -y mariadb-server mariadb-client

COPY /tools/dbsetup.sh /tmp/dbsetup.sh
RUN chmod +x /tmp/dbsetup.sh

EXPOSE 3306
ENTRYPOINT [ "/tmp/dbsetup.sh" ]