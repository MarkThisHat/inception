FROM alpine:3.20

# Install PHP 8 and needed extensions
RUN apk update && apk --no-cache add \
  php php-fpm php-mysqli php-session wget

# Ensure config directory exists before trying to modify it
RUN mkdir -p /etc/php8/php-fpm.d

# Configure PHP-FPM to listen on port 8000
RUN echo "listen = 0.0.0.0:8000" >> /etc/php8/php-fpm.d/www.conf

# Download Adminer
RUN wget https://github.com/vrana/adminer/releases/download/v5.2.1/adminer-5.2.1-en.php && \
    mkdir -p /var/www/adminer && \
    mv adminer-5.2.1-en.php /var/www/adminer/index.php && \
    chmod +x /var/www/adminer/index.php

# Copy and set up entrypoint
COPY tools/adminer-entrypoint.sh /usr/local/bin/adminer-entrypoint.sh
RUN chmod +x /usr/local/bin/adminer-entrypoint.sh

WORKDIR /var/www/adminer

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/adminer-entrypoint.sh"]
