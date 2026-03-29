#!/bin/sh
set -e

DB_DIR="/config/db"

echo "=== DEBUG: run.sh is executing ==="
echo "DB_DIR=$DB_DIR"
ls -la /config/ 2>&1 || echo "/config does not exist"
mkdir -p "$DB_DIR" 2>&1 || echo "Failed to create DB_DIR"
ls -la "$DB_DIR" 2>&1

rm -rf /var/lib/fmd-server/db
mkdir -p /var/lib/fmd-server
ln -s "$DB_DIR" /var/lib/fmd-server/db

ls -la /var/lib/fmd-server/ 2>&1
echo "=== Symlink target ==="
readlink /var/lib/fmd-server/db 2>&1

chown -R fmd-server:fmd-server "$DB_DIR" 2>&1 || echo "chown failed"

echo "Starting FMD server..."
exec su -s /bin/sh fmd-server -c "/opt/fmd-server serve --db-dir /var/lib/fmd-server/db"
