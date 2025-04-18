FROM alpine:3.20

RUN apk update && apk --no-cache add \
  php php-fpm php-mysqli php-session wget

RUN mkdir -p /etc/php8/php-fpm.d

RUN echo "listen = 0.0.0.0:8000" >> /etc/php8/php-fpm.d/www.conf

RUN wget https://github.com/vrana/adminer/releases/download/v5.2.1/adminer-5.2.1-en.php && \
    mkdir -p /var/www/adminer && \
    mv adminer-5.2.1-en.php /var/www/adminer/index.php && \
    chmod +x /var/www/adminer/index.php

COPY tools/adminer-entrypoint.sh /usr/local/bin/adminer-entrypoint.sh
RUN chmod +x /usr/local/bin/adminer-entrypoint.sh

WORKDIR /var/www/adminer

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/adminer-entrypoint.sh"]
