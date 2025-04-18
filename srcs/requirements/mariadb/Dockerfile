FROM alpine:3.20

ENV WP_DATABASE_NAME=${WP_DATABASE_NAME}
ENV WP_DATABASE_USER=${WP_DATABASE_USER}
ENV WP_DATABASE_PASSWORD=${WP_DATABASE_PASSWORD}
ENV WP_DATABASE_ROOT=${WP_DATABASE_ROOT}
ENV WP_DATABASE_ROOT_PASSWORD=${WP_DATABASE_ROOT_PASSWORD}

RUN apk update && apk add --no-cache \
    mariadb mariadb-client openrc bash

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
    chmod 770 /run/mysqld

COPY ./conf/my.cnf /etc/my.cnf

COPY ./tools/db-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/db-setup.sh

RUN /usr/local/bin/db-setup.sh

EXPOSE 3306

ENTRYPOINT ["mariadbd-safe"]
