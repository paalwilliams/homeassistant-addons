#!/bin/sh
set -e

DB_DIR="/config/db"

# Apply the configured timezone (defaults to UTC) so log timestamps are local
TZ=$(sed -n 's/.*"timezone"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' /data/options.json 2>/dev/null)
export TZ="${TZ:-UTC}"
echo "Using timezone: $TZ"

mkdir -p "$DB_DIR"

# symlink /var/lib/fmd-server/db/ to addon_config directory so data persists across reinstalls
rm -rf /var/lib/fmd-server/db
mkdir -p /var/lib/fmd-server
ln -s "$DB_DIR" /var/lib/fmd-server/db

chown -R fmd-server:fmd-server "$DB_DIR"

echo "Starting FMD server..."
exec su -s /bin/sh fmd-server -c "/opt/fmd-server serve --db-dir /var/lib/fmd-server/db"
