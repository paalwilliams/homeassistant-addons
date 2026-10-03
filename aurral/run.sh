#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

# Read the add-on options with node, which the image already ships
opt() {
    node -e 'const o = require(process.argv[1]); const v = o[process.argv[2]]; process.stdout.write(v === undefined || v === null ? "" : String(v))' "$OPTIONS_FILE" "$1"
}

# Aurral drops from root to PUID:PGID. /media and /share belong to root on
# Home Assistant OS, so the default of 0 lets it write to library and downloads
export PUID="$(opt PUID)"
export PGID="$(opt PGID)"

TZ="$(opt TZ)"
export TZ="${TZ:-UTC}"

# Extra environment for Aurral, e.g. OIDC_* or AUTH_PROXY_* for single sign-on
eval "$(node -e '
const o = require(process.argv[1]);
for (const { name, value } of o.env_vars || []) {
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(name)) { console.error(`skipping invalid env var name: ${name}`); continue; }
  console.log(`export ${name}=${JSON.stringify(value ?? "")}`);
}' "$OPTIONS_FILE")"

# Settings, database and jobs live in this add-on's config folder, which
# Home Assistant mounts at /config and includes in backups
export AURRAL_DATA_DIR=/config

echo "Starting Aurral (uid ${PUID}, gid ${PGID}, timezone ${TZ})..."
cd /app
exec docker-entrypoint.sh node backend/server.js
