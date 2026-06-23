#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

# Read a string option from options.json without depending on python/jq
# (the upstream rss-bridge image is debian-slim and ships neither).
config_get() {
    [ -f "$OPTIONS_FILE" ] || return 0
    sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$OPTIONS_FILE"
}

# Timezone (affects feed/log timestamps only)
TZ="$(config_get TZ)"
[ -n "$TZ" ] && export TZ

# RSS-Bridge reads optional config from /config (the addon_config share). The
# upstream entrypoint copies config.ini.php / whitelist.txt / *Bridge.php from
# /config into /app on every start, so anything placed here survives restarts
# and add-on updates. Edit these files via Samba/File Editor under
# /addon_configs/<repo>_rss-bridge/.
mkdir -p /config

# Seed a sensible default config the first time only. Keys not set here fall
# back to RSS-Bridge's built-in defaults, so this stays minimal on purpose.
if [ ! -f /config/config.ini.php ]; then
    cat > /config/config.ini.php <<'EOF'
; RSS-Bridge configuration (Home Assistant add-on)
; Only the keys below override defaults; everything else uses built-in defaults.
; Full reference:
;   https://github.com/RSS-Bridge/rss-bridge/blob/master/config.default.ini.php

[cache]
type = "file"
; Allow each feed URL to request its own cache duration via the
; &_cache_timeout=<seconds> parameter. Longer caches mean fewer upstream
; requests, which is the main lever against Instagram 429 rate-limiting.
custom_timeout = true

[error]
; Report errors inside the feed instead of failing the whole HTTP request, so
; one broken bridge doesn't take down an otherwise-working feed fetch.
output = "feed"
report_limit = 3
EOF
    echo "Seeded default /config/config.ini.php"
fi

echo "Starting RSS-Bridge..."
exec /app/docker-entrypoint.sh
