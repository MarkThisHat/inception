FROM alpine:3.20

RUN apk update && apk add --no-cache mariadb mariadb-client bash

COPY ./conf/my.cnf /etc/my.cnf

COPY ../tools/db-setup.sh /usr/local/bin/db-setup.sh
RUN chmod +x /usr/local/bin/db-setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/db-setup.sh"]
