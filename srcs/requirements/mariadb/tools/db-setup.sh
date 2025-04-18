#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data dir..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB..."
mysqld_safe --user=mysql &

until mariadb-admin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 1
done


echo "Creating database and users..."

mariadb --protocol=socket -u root <<EOF
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* TO '${WP_DATABASE_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS '${HEALTH_USER}'@'localhost' IDENTIFIED BY '${HEALTH_PASS}';
GRANT USAGE ON *.* TO '${HEALTH_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root --protocol=socket --socket=/run/mysqld/mysqld.sock -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

exec mariadbd --user=mysql
