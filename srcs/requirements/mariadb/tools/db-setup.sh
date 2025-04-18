#!/bin/bash

set -e

echo "DB: $WP_DATABASE_NAME, User: $WP_DATABASE_USER"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data dir..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe &
sleep 5

echo "Creating database and users..."
mariadb -u root <<EOF
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* TO '${WP_DATABASE_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop the temporary MariaDB
mysqladmin -u root -p${WP_DATABASE_ROOT_PASSWORD} shutdown

# Replace the running process with actual server
exec mariadbd
