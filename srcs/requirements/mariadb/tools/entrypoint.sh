#!/bin/bash
set -e

INIT_MARKER=/var/lib/mysql/.mariadb_initialized

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -f "$INIT_MARKER" ]; then
  echo "[MariaDB] First run detected. Generating init.sql..."
  envsubst '$WP_DATABASE_NAME $WP_DATABASE_USER $WP_DATABASE_PASSWORD $WP_DATABASE_ROOT_PASSWORD $HEALTH_USER $HEALTH_PASS' < /etc/init-template.sql > /etc/init.sql
  rm /etc/init-template.sql

  echo "[MariaDB] Initializing data directory..."
  if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  fi

  echo "[MariaDB] Starting temporary server..."
  mysqld_safe --user=mysql &

  echo "[MariaDB] Waiting for server to become ready..."
  until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
    sleep 1
  done

  echo "[MariaDB] Running init.sql setup..."
  mariadb --protocol=socket -u root < /etc/init.sql

  echo "[MariaDB] Shutting down temporary server..."
  mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

  touch "$INIT_MARKER"
  echo "[MariaDB] First-time setup complete."
else
  echo "[MariaDB] Normal startup. Skipping initialization."
fi

echo "[MariaDB] Starting main server..."
exec mariadbd --user=mysql
