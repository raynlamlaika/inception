#!/bin/bash
set -e

echo "Starting MariaDB setup..."

# start temporary server in safe init mode
mariadbd --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS WPDATABASE_NAME;

CREATE USER IF NOT EXISTS 'WPDATABASE_USER'@'%' IDENTIFIED BY 'WPDATABASE_PASSWORD';

GRANT ALL PRIVILEGES ON WPDATABASE_NAME.* TO 'WPDATABASE_USER'@'%';

FLUSH PRIVILEGES;
EOF

echo "Initialization done."

# IMPORTANT: start REAL server
exec mariadbd --user=mysql --console