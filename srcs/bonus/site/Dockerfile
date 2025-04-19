FROM alpine:3.20

RUN apk update && apk add --no-cache python3 py-pip py-virtualenv bash

RUN python3 -m venv /env && \
    /env/bin/pip install Flask gunicorn

COPY ./tools/ /var/www/wordpress/site/
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]
