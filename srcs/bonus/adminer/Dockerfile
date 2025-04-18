FROM alpine:3.20

COPY tools/adminer-entrypoint.sh /tmp/adminer-entrypoint.sh
RUN chmod +x /tmp/adminer-entrypoint.sh

WORKDIR /tmp
RUN apk update && apk --no-cache add php php-fpm php-mysqli php-session \
    && wget https://github.com/vrana/adminer/releases/download/v5.2.1/adminer-5.2.1-en.php \
    && chmod +x adminer-5.2.1-en.php \
    && mkdir -p /var/www/adminer \
    && mv adminer-5.2.1-en.php /var/www/adminer/index.php

EXPOSE 8000
RUN echo "listen = 0.0.0.0:8000" >> /etc/php/php-fpm.d/www.conf

ENTRYPOINT [ "ash", "-f", "./adminer-entrypoint.sh" ]
