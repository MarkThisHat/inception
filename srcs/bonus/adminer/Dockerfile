FROM alpine:3.20

RUN apk update && apk --no-cache add \
  php php-fpm php-mysqli php-session curl

RUN mkdir -p /var/www/adminer && \
    curl -L https://github.com/vrana/adminer/releases/download/v5.2.1/adminer-5.2.1-en.php -o /var/www/adminer/index.php && \
    mv adminer-5.2.1-en.php /var/www/adminer/index.php && \
		chmod +x /var/www/adminer/index.php

RUN echo "listen = 0.0.0.0:8000" >> /etc/php83/php-fpm.d/www.conf

COPY tools/adminer-entrypoint.sh /usr/local/bin/adminer-entrypoint.sh
RUN chmod +x /usr/local/bin/adminer-entrypoint.sh

WORKDIR /var/www/adminer

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/adminer-entrypoint.sh"]
