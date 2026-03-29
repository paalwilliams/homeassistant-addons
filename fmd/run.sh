#!/bin/sh
set -e

DB_DIR="/config/db"

mkdir -p "$DB_DIR"

# FMD server stores its database in /var/lib/fmd-server/db/
# Symlink it to HA's addon_config directory so data persists across reinstalls
rm -rf /var/lib/fmd-server/db
mkdir -p /var/lib/fmd-server
ln -s "$DB_DIR" /var/lib/fmd-server/db

chown -R fmd-server:fmd-server "$DB_DIR"

echo "Starting FMD server..."
exec su -s /bin/sh fmd-server -c "/opt/fmd-server serve --db-dir /var/lib/fmd-server/db"
