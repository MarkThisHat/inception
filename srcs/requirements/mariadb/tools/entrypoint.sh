#!/bin/bash

set -e

envsubst '$WP_DATABASE_NAME $WP_DATABASE_USER $WP_DATABASE_PASSWORD $WP_DATABASE_ROOT_PASSWORD $HEALTH_USER $HEALTH_PASS' < /etc/init-template.sql > /etc/init.sql
rm /etc/init-template.sql

echo "[MariaDB] Starting server in the background..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[MariaDB] Initializing data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "[MariaDB] Starting temporary server..."
mysqld_safe --user=mysql &

echo "[MariaDB] Waiting for server to become ready..."
until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
  sleep 1
done

if mariadb --protocol=socket -u root -e "USE \`${WP_DATABASE_NAME}\`;" 2>/dev/null; then
  echo "Database '${WP_DATABASE_NAME}' already exists. Skipping initialization."
else
  echo "[MariaDB] Setting up database and users..."
  mariadb --protocol=socket -u root < /etc/init.sql
fi

echo "[MariaDB] Shutting down temporary server..."
mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

echo "[MariaDB] Initialization complete. Starting main server..."
exec mariadbd --user=mysql
