#!/bin/bash

mariadb-install-db --user=mysql --datadir=/var/lib/mysql

mariadbd-safe --datadir=/var/lib/mysql &
sleep 5

mariadb -u root <<EOF
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS ${WP_DATABASE_NAME};
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WP_DATABASE_NAME}.* TO '${WP_DATABASE_USER}'@'%';
ALTER USER '${WP_DATABASE_ROOT}'@'localhost' IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mariadb-admin -u root -p${WP_DATABASE_ROOT_PASSWORD} shutdown
