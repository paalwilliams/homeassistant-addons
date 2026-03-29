#!/usr/bin/env bashio
set -e

mkdir -p /data/db

bashio::log.info "Starting FMD server..."
exec fmd-server serve
