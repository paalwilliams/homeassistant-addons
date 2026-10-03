#!/bin/sh
set -e

DATA_DIR="/config"

opt() {
    sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" /data/options.json 2>/dev/null || true
}

# Apply the configured timezone (defaults to UTC) so log timestamps are local
TZ=$(opt timezone)
export TZ="${TZ:-UTC}"
echo "Using timezone: $TZ"

FUTO_NOTES_PASSWORD=$(opt password)
if [ -z "$FUTO_NOTES_PASSWORD" ]; then
    echo "ERROR: set a sync password in the app configuration before starting" >&2
    exit 1
fi
export FUTO_NOTES_PASSWORD

# Keep the database and encrypted blobs in addon_config so they persist across reinstalls
mkdir -p "$DATA_DIR/db" "$DATA_DIR/blobs"
chown notes:notes "$DATA_DIR" "$DATA_DIR/db" "$DATA_DIR/blobs"

export PORT=3000
export BLOB_DIR="$DATA_DIR/blobs"
export DATABASE_URL="sqlite:$DATA_DIR/db/notes.db"

echo "Starting FUTO Notes server..."
exec gosu notes futo-notes-server
