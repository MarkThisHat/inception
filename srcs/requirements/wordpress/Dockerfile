FROM alpine:3.20

RUN apk update && apk add --no-cache \
    php php-fpm php-mysqli \
    php-phar php-json php-curl php-opcache \
    php-common php-mbstring php-tokenizer \
    mariadb-client curl

WORKDIR /var/www/wordpress

RUN curl -LO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

RUN echo "listen = 0.0.0.0:9000" >> /etc/php83/php-fpm.d/www.conf && \
echo "clear_env = no" >> /etc/php83/php-fpm.d/www.conf

STOPSIGNAL SIGQUIT

COPY tools/wp-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/wp-entrypoint.sh

ENTRYPOINT ["/usr/bin/wp-entrypoint.sh"]
CMD ["php-fpm83", "-F"]
