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
config_export DB_HOST
config_export DB_PORT
config_export DB_NAME
config_export DB_USER
config_export DB_PASSWD

# Auth configuration
config_export ROMM_AUTH_SECRET_KEY
config_export ROMM_AUTH_USERNAME
config_export ROMM_AUTH_PASSWORD

# ROM library path
config_export ROMM_BASE_PATH

# Metadata provider keys (optional)
config_export IGDB_CLIENT_ID
config_export IGDB_CLIENT_SECRET
config_export SCREENSCRAPER_USER
config_export SCREENSCRAPER_PASSWORD
config_export MOBYGAMES_API_KEY
config_export STEAMGRIDDB_API_KEY

# Timezone
config_export TZ

# Ensure ROM base path exists
mkdir -p "${ROMM_BASE_PATH}"

echo "Starting RomM..."
exec /entrypoint.sh
