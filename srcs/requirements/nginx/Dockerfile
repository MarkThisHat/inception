FROM alpine:3.20

ARG UID
ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apk update && apk add --no-cache nginx openssl gettext shadow curl

RUN adduser -u ${UID} -G www-data -D -s /sbin/nologin nginxuser && \
    mkdir -p /etc/nginx/ssl /var/www/wordpress /var/www/adminer /var/lib/nginx/logs && \
    chown -R nginxuser:www-data /var/www /etc/nginx /var/log/nginx /var/lib/nginx /etc/nginx/ssl && \
    chmod 755 /var/lib/nginx /var/lib/nginx/logs && \
    touch /var/lib/nginx/logs/error.log && \
    chown nginxuser:www-data /var/lib/nginx/logs/error.log && \
    chmod 755 /var/lib/nginx/logs/error.log && \
    mkdir -p /run/nginx && \
    chown -R nginxuser:www-data /run/nginx

COPY ./conf/nginx-template.conf /etc/nginx/nginx-template.conf
COPY ./conf/certificate.pem /etc/nginx/ssl/certificate.pem
COPY ./conf/private.key /etc/nginx/ssl/private.key
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

USER nginxuser

ENTRYPOINT ["/entrypoint.sh"]
