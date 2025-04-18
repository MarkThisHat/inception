#!/bin/bash
set -e

echo "DB: $WP_DATABASE_NAME, User: $WP_DATABASE_USER, Psswd: $WP_DATABASE_PASSWORD, DBroot: $WP_DATABASE_ROOT, DBPsswd $WP_DATABASE_ROOT_PASSWORD"

# Ensure the data directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data dir..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start mysqld as mysql user
echo "Starting MariaDB..."
mysqld_safe --user=mysql &
sleep 5

echo "Creating database and users..."

# Use root via socket (no password)
mariadb --protocol=socket -u root <<EOF
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS \`${WP_DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DATABASE_USER}'@'%' IDENTIFIED BY '${WP_DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_DATABASE_NAME}\`.* TO '${WP_DATABASE_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DATABASE_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Shut down cleanly
mysqladmin --protocol=socket -u root -p"${WP_DATABASE_ROOT_PASSWORD}" shutdown

# Launch MariaDB normally
exec mariadbd --user=mysql
