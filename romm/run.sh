#!/usr/bin/env bashio

# Database configuration
export DB_HOST="$(bashio::config 'DB_HOST')"
export DB_PORT="$(bashio::config 'DB_PORT')"
export DB_NAME="$(bashio::config 'DB_NAME')"
export DB_USER="$(bashio::config 'DB_USER')"
export DB_PASSWD="$(bashio::config 'DB_PASSWD')"

# Auth configuration
export ROMM_AUTH_SECRET_KEY="$(bashio::config 'ROMM_AUTH_SECRET_KEY')"
if bashio::config.has_value 'ROMM_AUTH_USERNAME'; then
    export ROMM_AUTH_USERNAME="$(bashio::config 'ROMM_AUTH_USERNAME')"
fi
if bashio::config.has_value 'ROMM_AUTH_PASSWORD'; then
    export ROMM_AUTH_PASSWORD="$(bashio::config 'ROMM_AUTH_PASSWORD')"
fi

# ROM library path
export ROMM_BASE_PATH="$(bashio::config 'ROMM_BASE_PATH')"

# Metadata provider keys (optional)
if bashio::config.has_value 'IGDB_CLIENT_ID'; then
    export IGDB_CLIENT_ID="$(bashio::config 'IGDB_CLIENT_ID')"
fi
if bashio::config.has_value 'IGDB_CLIENT_SECRET'; then
    export IGDB_CLIENT_SECRET="$(bashio::config 'IGDB_CLIENT_SECRET')"
fi
if bashio::config.has_value 'SCREENSCRAPER_USER'; then
    export SCREENSCRAPER_USER="$(bashio::config 'SCREENSCRAPER_USER')"
fi
if bashio::config.has_value 'SCREENSCRAPER_PASSWORD'; then
    export SCREENSCRAPER_PASSWORD="$(bashio::config 'SCREENSCRAPER_PASSWORD')"
fi
if bashio::config.has_value 'MOBYGAMES_API_KEY'; then
    export MOBYGAMES_API_KEY="$(bashio::config 'MOBYGAMES_API_KEY')"
fi
if bashio::config.has_value 'STEAMGRIDDB_API_KEY'; then
    export STEAMGRIDDB_API_KEY="$(bashio::config 'STEAMGRIDDB_API_KEY')"
fi

# Timezone
export TZ="$(bashio::config 'TZ')"

# Ensure ROM base path exists
mkdir -p "${ROMM_BASE_PATH}"

bashio::log.info "Starting RomM..."
exec /entrypoint.sh
