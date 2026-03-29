#!/usr/bin/env bashio
set -e

# Ensure persistent DB folder exists
mkdir -p /data/db

bashio::log.info "Starting FMD server..."
exec fmd-server serve
