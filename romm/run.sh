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

# Persist ROMM data directories to /data (survives restarts)
for dir in config assets resources; do
    mkdir -p "/data/romm/${dir}"
    # Copy any existing persistent data back into the container
    cp -a "/data/romm/${dir}/." "/romm/${dir}/" 2>/dev/null || true
done

# Ensure config.yml exists
if [ ! -f /romm/config/config.yml ]; then
    touch /romm/config/config.yml
fi

# Ensure library directory exists
mkdir -p /romm/library

# If user set a custom ROMM_BASE_PATH, symlink their library content into /romm/library
if [ "${ROMM_BASE_PATH}" != "/romm" ] && [ -d "${ROMM_BASE_PATH}/library" ]; then
    # Symlink each platform directory from user's library
    for dir in "${ROMM_BASE_PATH}/library"/*; do
        [ -e "$dir" ] || continue
        base="$(basename "$dir")"
        if [ ! -e "/romm/library/$base" ]; then
            ln -s "$dir" "/romm/library/$base"
        fi
    done
fi

# Force ROMM_BASE_PATH to /romm so nginx paths work
export ROMM_BASE_PATH="/romm"

# Disable filesystem watcher if library is empty to avoid crash-looping
export ENABLE_RESCAN_ON_FILESYSTEM_CHANGE="${ENABLE_RESCAN_ON_FILESYSTEM_CHANGE:-true}"

# Sync persistent data back to /data on shutdown
trap 'for dir in config assets resources; do cp -a "/romm/${dir}/." "/data/romm/${dir}/" 2>/dev/null || true; done' EXIT

echo "Starting RomM..."
/docker-entrypoint.sh /init
