#!/bin/bash
set -e

OPTIONS_FILE="/data/options.json"
DATA_DIR="/data/wger"
SECRETS_FILE="${DATA_DIR}/secrets.env"

mkdir -p "${DATA_DIR}/media" "${DATA_DIR}/beat"

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

# Previously generated secrets (see below), so they survive restarts
if [ -f "$SECRETS_FILE" ]; then
    # shellcheck disable=SC1090
    . "$SECRETS_FILE"
fi

# Security keys. Anything set in the addon options wins over the generated ones
config_export SECRET_KEY
config_export JWT_PRIVATE_KEY
config_export JWT_PUBLIC_KEY

# Database configuration
config_export DJANGO_DB_ENGINE
config_export DJANGO_DB_HOST
config_export DJANGO_DB_PORT
config_export DJANGO_DB_DATABASE
config_export DJANGO_DB_USER
config_export DJANGO_DB_PASSWORD

# Application settings
config_export ALLOW_REGISTRATION
config_export ALLOW_GUEST_USERS
config_export SITE_URL
config_export CSRF_TRUSTED_ORIGINS
config_export TZ
if [ -n "${TZ:-}" ]; then
    export TIME_ZONE="${TZ}"
fi

# A missing route to postgres makes every step that loads django block on a TCP
# connect that never completes, with no output at all. Fail fast and say why
export PGCONNECT_TIMEOUT="10"

db_host="$(config_get DJANGO_DB_HOST)"
db_port="$(config_get DJANGO_DB_PORT)"
db_port="${db_port:-5432}"

echo "Checking that postgres is reachable at ${db_host}:${db_port}..."
if ! python3 -c "
import socket, sys
try:
    socket.create_connection(('${db_host}', ${db_port}), timeout=10).close()
except OSError as error:
    sys.exit(str(error))
"; then
    echo "ERROR: could not reach postgres at ${db_host}:${db_port}"
    echo "ERROR: check the DJANGO_DB_HOST and DJANGO_DB_PORT options, that the"
    echo "ERROR: database server is running, and that it accepts connections"
    echo "ERROR: from this host."
    exit 1
fi

# Persist a secret so it stays stable across restarts
persist_secret() {
    touch "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"
    echo "export $1='$2'" >> "$SECRETS_FILE"
}

# Django secret key. Without a stable one all sessions are invalidated on restart
if [ -z "${SECRET_KEY:-}" ]; then
    echo "No SECRET_KEY configured, generating one..."
    SECRET_KEY="$(python3 -c 'import secrets; print(secrets.token_urlsafe(50))')"
    export SECRET_KEY
    persist_secret SECRET_KEY "$SECRET_KEY"
fi

# Run migrations automatically
export DJANGO_PERFORM_MIGRATIONS="True"

# Static files
export DJANGO_DEBUG="False"
export DJANGO_CLEAR_STATIC_FIRST="False"
export DJANGO_COLLECTSTATIC_ON_STARTUP="True"

# Use gunicorn, behind the bundled nginx (which serves /static/ and /media/)
export WGER_USE_GUNICORN="True"
export WGER_PORT="8001"
export NUMBER_OF_PROXIES="1"

# Bundled Redis for cache and Celery broker
export DJANGO_CACHE_BACKEND="django_redis.cache.RedisCache"
export DJANGO_CACHE_LOCATION="redis://127.0.0.1:6379/1"
export DJANGO_CACHE_TIMEOUT="1296000"
export DJANGO_CACHE_CLIENT_CLASS="django_redis.client.DefaultClient"
export USE_CELERY="True"
export CELERY_BROKER="redis://127.0.0.1:6379/2"
export CELERY_BACKEND="redis://127.0.0.1:6379/2"

# Sync exercises and images via Celery
export SYNC_EXERCISES_CELERY="True"
export SYNC_EXERCISE_IMAGES_CELERY="True"
export SYNC_EXERCISE_VIDEOS_CELERY="True"

# Persistent media storage
chown -R wger:wger "$DATA_DIR"
rm -rf /home/wger/media 2>/dev/null || true
ln -sfn "${DATA_DIR}/media" /home/wger/media
ln -sfn "${DATA_DIR}/beat" /home/wger/beat

cd /home/wger/src

# JWT keypair, used by the mobile app. Generated once and then persisted.
# Bounded by a timeout so a failure here can never wedge the add-on's startup
if [ -z "${JWT_PRIVATE_KEY:-}" ] || [ -z "${JWT_PUBLIC_KEY:-}" ]; then
    echo "No JWT keypair configured, generating one..."
    jwt_output="$(timeout 120 gosu wger env HOME=/home/wger /usr/local/bin/wger-gen-jwt-keys || true)"
    jwt_private="$(echo "$jwt_output" | sed -n 's/^JWT_PRIVATE_KEY=//p')"
    jwt_public="$(echo "$jwt_output" | sed -n 's/^JWT_PUBLIC_KEY=//p')"
    if [ -n "$jwt_private" ] && [ -n "$jwt_public" ]; then
        export JWT_PRIVATE_KEY="$jwt_private"
        export JWT_PUBLIC_KEY="$jwt_public"
        persist_secret JWT_PRIVATE_KEY "$jwt_private"
        persist_secret JWT_PUBLIC_KEY "$jwt_public"
        echo "Generated a JWT keypair, stored in ${SECRETS_FILE}"
    else
        echo "WARNING: could not generate a JWT keypair, continuing anyway."
        echo "WARNING: log in from the mobile app will not work until this is fixed."
    fi
fi

# Start Redis in the background
redis-server --daemonize yes --bind 127.0.0.1 --port 6379 \
    --dir /var/lib/redis --pidfile /var/run/redis/redis.pid

# Start Celery worker in the background (as wger user)
gosu wger env HOME=/home/wger celery -A wger worker --loglevel=info --detach \
    --pidfile=/tmp/celery-worker.pid --logfile=/tmp/celery-worker.log

# Start Celery beat in the background (as wger user)
gosu wger env HOME=/home/wger celery -A wger beat --loglevel=info --detach \
    --pidfile=/tmp/celery-beat.pid --logfile=/tmp/celery-beat.log \
    --schedule="${DATA_DIR}/beat/celerybeat-schedule"

# Start nginx in the background. It listens on 8000 and proxies to gunicorn
nginx

echo "Starting wger..."
exec gosu wger env HOME=/home/wger /home/wger/entrypoint.sh
