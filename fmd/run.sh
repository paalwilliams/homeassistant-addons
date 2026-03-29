#!/usr/bin/env bashio
set -e

# Ensure persistent DB directory
mkdir -p /data/db

# Only create symlink if it doesn't exist
if [ ! -L /var/lib/fmd-server/db ]; then
    rm -rf /var/lib/fmd-server/db
    ln -s /data/db /var/lib/fmd-server/db
fi

bashio::log.info "Starting FMD server..."
exec fmd-server
