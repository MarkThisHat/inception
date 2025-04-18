FROM alpine:3.20

COPY tools/adminer-entrypoint.sh /tmp/adminer-entrypoint.sh
RUN chmod +x /tmp/adminer-entrypoint.sh

WORKDIR /tmp

RUN apk update && apk --no-cache add php8 php8-fpm php8-mysqli php8-session wget \
    && wget https://github.com/vrana/adminer/releases/download/v4.8.4/adminer-4.8.4-en.php \
    && chmod +x adminer-4.8.4-en.php \
    && mkdir -p /var/www/adminer \
    && mv adminer-4.8.4-en.php /var/www/adminer/index.php

EXPOSE 8000

RUN echo "listen = 0.0.0.0:8000" >> /etc/php8/php-fpm.d/www.conf

ENTRYPOINT [ "ash", "-f", "./adminer-entrypoint.sh" ]
