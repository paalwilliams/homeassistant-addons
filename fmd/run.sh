#!/usr/bin/env bashio

mkdir -p /data/db
rm -rf /var/lib/fmd-server/db
ln -s /data/db /var/lib/fmd-server/db
