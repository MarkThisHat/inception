FROM alpine:3.20

RUN apk update && apk add --no-cache mariadb mariadb-client bash gettext

COPY ./conf/my.cnf /etc/my.cnf

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY ./conf/init-template.sql /etc/init-template.sql

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]