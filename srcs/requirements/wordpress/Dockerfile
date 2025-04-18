FROM alpine:3.20

RUN apk update && apk add --no-cache \
    php php-fpm php-mysqli \
    mariadb-client curl wget

RUN echo "listen = 0.0.0.0:9000" >> /etc/php8/php-fpm.d/www.conf && \
    echo "clear_env = no" >> /etc/php8/php-fpm.d/www.conf

WORKDIR /var/www/wordpress

RUN curl -LO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --allow-root

STOPSIGNAL SIGQUIT

COPY tools/wp-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/wp-entrypoint.sh

ENTRYPOINT ["/usr/bin/wp-entrypoint.sh"]
CMD ["php-fpm8", "-F"]
