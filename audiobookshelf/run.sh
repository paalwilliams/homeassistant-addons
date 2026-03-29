#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

# Helper to read a config value from options.json
config_get() {
    node -e "const o=require('$OPTIONS_FILE'); const v=o['$1']; if(v !== undefined && v !== '') process.stdout.write(String(v))"
}

# Export config values as environment variables
for key in CONFIG_PATH METADATA_PATH BACKUP_PATH ALLOW_CORS ALLOW_IFRAME TZ ACCESS_TOKEN_EXPIRY REFRESH_TOKEN_EXPIRY; do
    val="$(config_get "$key")"
    if [ -n "$val" ]; then
        export "$key"="$val"
    fi
done

exec /usr/bin/audiobookshelf
