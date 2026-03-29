#!/bin/sh
set -e

mkdir -p /data/db

# FMD server stores its database in /var/lib/fmd-server/db/
# Symlink it to HA's persistent /data directory so data survives restarts
rm -rf /var/lib/fmd-server/db
mkdir -p /var/lib/fmd-server
ln -s /data/db /var/lib/fmd-server/db

echo "Starting FMD server..."
exec fmd-server serve
