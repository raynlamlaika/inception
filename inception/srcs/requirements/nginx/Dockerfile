

FROM debian:bookworm


RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y nginx openssl



RUN mkdir -p /etc/nginx/ssl

# nodes stands for "no DES" which means that the private key will not be encrypted with a passphrase. 
# This is necessary for NGINX to be able to read the private key without requiring user input for the passphrase when starting the server.


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MO/ST=KH/L=Khouribga/O=42/OU=42/CN=localhost/UID=rlamlaik"
# Copy your custom configuration file

COPY tools/nginx.conf /etc/nginx/conf.d/default.conf

# NGINX runs on port 443 for HTTPS

EXPOSE 443


# Run NGINX in the foreground (daemon off) to keep container alive
#-g stand for "global directives" and "daemon off" tells NGINX to run in the foreground, which is necessary for Docker containers to keep running. If NGINX were to run in the background (the default behavior), the container would exit immediately after starting, as there would be no foreground process to keep it alive.

CMD ["nginx", "-g", "daemon off;"]


