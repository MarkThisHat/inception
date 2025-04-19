FROM alpine:3.20

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/ /var/www/site/

RUN apk update && apk add --no-cache nginx python3 py3-pip && \
    pip install Flask

RUN chmod +x /var/www/site/entrypoint.sh
ENTRYPOINT ["/var/www/site/entrypoint.sh"]
