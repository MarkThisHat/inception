FROM alpine:3.20

RUN apk update && apk add --no-cache redis

COPY ./conf/redis.conf /etc/redis/redis.conf
RUN mkdir /data && chown redis:redis /data

EXPOSE 6379
ENTRYPOINT [ "redis-server", "/etc/redis/redis.conf" ]
