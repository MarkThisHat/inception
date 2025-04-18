#!/bin/sh
set -e

echo "Waiting for MariaDB at $WP_DATABASE_HOST..."
until mysqladmin ping -h"$WP_DATABASE_HOST" --silent; do
  echo "Waiting..."
  sleep 1
done
echo "MariaDB is up."

if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
  echo "Installing WordPress..."

  wp config create --allow-root \
    --path=/var/www/wordpress \
    --dbname="$WP_DATABASE_NAME" \
    --dbuser="$WP_DATABASE_USER" \
    --dbpass="$WP_DATABASE_PASSWORD" \
    --dbhost="$WP_DATABASE_HOST" \
    --dbprefix='wp_' \
    --dbcharset='utf8'

  wp core install --allow-root \
    --path=/var/www/wordpress \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email

  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASSWORD" \
    --role=author \
    --path=/var/www/wordpress \
    --allow-root

  wp plugin install redis-cache --activate --allow-root --path=/var/www/wordpress
  wp config set WP_REDIS_HOST "$REDIS_HOST" --allow-root --path=/var/www/wordpress
  wp config set WP_REDIS_PORT "$REDIS_PORT" --allow-root --path=/var/www/wordpress
  wp redis enable --allow-root --path=/var/www/wordpress

  chown -R nginx:nginx /var/www/wordpress
  chmod -R 775 /var/www/wordpress
fi

echo "WordPress is ready"
exec php-fpm83 -F
