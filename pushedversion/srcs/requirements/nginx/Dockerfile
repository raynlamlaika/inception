FROM debain:bookworm


RUN apt-get update && apt-get install -y nginx

RUN mkdir -p /etc/nginx/ssl


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MO/ST=KH/L=Khouribga/O=42/OU=42/CN=localhost/UID=rlamlaik"

COPY tools/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]