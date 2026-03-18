FROM debian:bookworm-slim

#craet  user in here

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash rayn
USER  rayn

WORKDIR /app


COPY miniserv.c .

RUN gcc miniserv.c -o serv


EXPOSE 1227


CMD ["./serv"]
