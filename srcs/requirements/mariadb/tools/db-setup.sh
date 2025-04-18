#!/bin/bash
set -e

echo "\n\nDB: $WP_DATABASE_NAME, User: $WP_DATABASE_USER\n\n"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data dir..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe &
sleep 5

echo "Creating database and users..."

if mariadb -u root --connect-expired-password -e "SELECT 1;" 2>/dev/null; then
    ROOT_LOGIN="mariadb -u root --connect-expired-password"
else
    ROOT_LOGIN="mariadb -u root -p${WP_DATABASE_ROOT_PASSWORD} --connect-expired-password"
fi

eval $ROOT_LOGIN <<EOF
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* TO '${WP_DATABASE_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

exec mariadbd
