FROM alpine:3.20

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apk update && apk add --no-cache nginx openssl gettext shadow

RUN useradd -r -u 1000 -g www-data -s /sbin/nologin nginxuser && \
    mkdir -p /etc/nginx/ssl /var/www/wordpress /var/www/adminer && \
    openssl req -newkey rsa:2048 -nodes \
      -keyout /etc/nginx/ssl/private.key \
      -x509 -days 365 \
      -out /etc/nginx/ssl/certificate.pem \
      -subj "/C=BR/ST=SP/L=SãoPaulo/O=42sp/CN=${DOMAIN_NAME}" && \
    chown -R nginxuser:www-data /var/www /etc/nginx /var/log/nginx /etc/nginx/ssl

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

USER nginxuser

ENTRYPOINT ["/entrypoint.sh"]

