FROM alpine:3.20

RUN apk add --no-cache nodejs npm \
  && mkdir -p /opt/site /var/www/site

COPY tools/index.html /opt/site/
COPY tools/server.js /opt/site/

WORKDIR /opt/site

CMD [ "node", "server.js" ]
