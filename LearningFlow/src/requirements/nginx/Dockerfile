FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

#make the ssl certs
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt -subj "/CN=localhost" \
    && chmod 600 /etc/ssl/private/nginx.key

COPY ./.config /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]