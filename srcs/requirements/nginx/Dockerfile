FROM alpine:3.20

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apk update && apk add --no-cache nginx openssl gettext shadow

# Create nginx user and directories
RUN useradd -r -u 1000 -g www-data -s /sbin/nologin nginxuser && \
    mkdir -p /etc/nginx/ssl /var/www/wordpress /var/www/adminer /var/lib/nginx/logs && \
    openssl req -newkey rsa:2048 -nodes \
      -keyout /etc/nginx/ssl/private.key \
      -x509 -days 365 \
      -out /etc/nginx/ssl/certificate.pem \
      -subj "/C=BR/ST=SP/L=SãoPaulo/O=42sp/CN=${DOMAIN_NAME}" && \
    chown -R nginxuser:www-data /var/www /etc/nginx /var/log/nginx /var/lib/nginx /etc/nginx/ssl && \
    chmod 755 /var/lib/nginx /var/lib/nginx/logs && \
    touch /var/lib/nginx/logs/error.log && \
    chown nginxuser:www-data /var/lib/nginx/logs/error.log && \
    chmod 755 /var/lib/nginx/logs/error.log

COPY ./conf/nginx-template.conf /etc/nginx/nginx-template.conf
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

# Use the user 'nginxuser' for the container process
USER nginxuser

ENTRYPOINT ["/entrypoint.sh"]
