FROM debian:bullseye


RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y nginx openssl



RUN mkdir -p /etc/nginx/ssl


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MO/ST=KH/L=Khouribga/O=42/OU=42/CN=localhost/UID=rlamlaik"
# Copy your custom configuration file

COPY serv.conf /etc/nginx/conf.d/default.conf

# NGINX runs on port 443 for HTTPS
EXPOSE 443

# Run NGINX in the foreground (daemon off) to keep container alive
CMD ["nginx", "-g", "daemon off;"]