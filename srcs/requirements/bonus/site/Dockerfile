FROM alpine:3.20

RUN apk add --no-cache nodejs npm

WORKDIR /app

COPY ./tools/index.html ./index.html
COPY ./tools/server.js ./server.js

CMD ["sh", "-c", "cp /app/index.html /var/www/site/index.html && node /app/server.js"]
