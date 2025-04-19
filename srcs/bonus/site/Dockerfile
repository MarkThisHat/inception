FROM alpine:3.20

RUN apk update && apk add --no-cache \
    nginx \ python3 \ py-pip \
    py-virtualenv \ bash

RUN mkdir -p /var/www/site /run/nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./tools/ /var/www/site/

RUN python3 -m venv /env && \
    /env/bin/pip install Flask gunicorn

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7000

ENTRYPOINT ["/entrypoint.sh"]
