#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

# Helper to read a config value from options.json
config_get() {
    python3 -c "import json; o=json.load(open('$OPTIONS_FILE')); v=o.get('$1',''); print(v if v is not None else '')"
}

# Helper to export a config value only if non-empty
config_export() {
    val="$(config_get "$1")"
    if [ -n "$val" ]; then
        export "$1"="$val"
    fi
}

# Database configuration
config_export ROMM_DB_DRIVER
config_export DB_HOST
config_export DB_PORT
config_export DB_NAME
config_export DB_USER
config_export DB_PASSWD

# Auth configuration
config_export ROMM_AUTH_SECRET_KEY
config_export ROMM_AUTH_USERNAME
config_export ROMM_AUTH_PASSWORD

# ROM library path (user-configured, e.g. /media/romm)
config_export ROMM_BASE_PATH
USER_LIBRARY="${ROMM_BASE_PATH}/library"

# Metadata provider keys (optional)
config_export IGDB_CLIENT_ID
config_export IGDB_CLIENT_SECRET
config_export SCREENSCRAPER_USER
config_export SCREENSCRAPER_PASSWORD
config_export MOBYGAMES_API_KEY
config_export STEAMGRIDDB_API_KEY

# Timezone
config_export TZ

# Use /data/romm for persistent storage (assets, resources, config)
export ROMM_BASE_PATH="/data/romm"
mkdir -p /data/romm/config /data/romm/assets /data/romm/resources /data/romm/library

# Ensure config.yml exists
if [ ! -f /data/romm/config/config.yml ]; then
    touch /data/romm/config/config.yml
fi

# Repoint frontend symlinks to persistent storage so nginx serves saved assets
ln -sf /data/romm/assets /var/www/html/assets/romm/assets
ln -sf /data/romm/resources /var/www/html/assets/romm/resources

# Symlink user's ROM library into persistent storage
if [ -n "${USER_LIBRARY}" ] && [ -d "${USER_LIBRARY}" ]; then
    for dir in "${USER_LIBRARY}"/*; do
        [ -e "$dir" ] || continue
        base="$(basename "$dir")"
        if [ ! -e "/data/romm/library/$base" ]; then
            ln -s "$dir" "/data/romm/library/$base"
        fi
    done
fi

# Nginx internal redirect expects /romm/library — symlink to persistent library
rm -rf /romm/library 2>/dev/null || true
ln -sf /data/romm/library /romm/library 2>/dev/null || true

echo "Starting RomM..."
exec /docker-entrypoint.sh /init
