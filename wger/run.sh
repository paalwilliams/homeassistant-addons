#!/bin/bash
set -e

OPTIONS_FILE="/data/options.json"

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

# Security keys
config_export SECRET_KEY
config_export SIGNING_KEY

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
config_export TZ
export TIME_ZONE="${TZ}"

# Run migrations automatically
export DJANGO_PERFORM_MIGRATIONS="True"

# Static files
export DJANGO_DEBUG="False"
export DJANGO_CLEAR_STATIC_FIRST="False"
export DJANGO_COLLECTSTATIC_ON_STARTUP="True"

# Use gunicorn
export WGER_USE_GUNICORN="True"

# Bundled Redis for cache and Celery broker
export DJANGO_CACHE_BACKEND="django_redis.cache.RedisCache"
export DJANGO_CACHE_LOCATION="redis://127.0.0.1:6379/1"
export DJANGO_CACHE_TIMEOUT="1296000"
export DJANGO_CACHE_CLIENT_CLASS="django_redis.client.DefaultClient"
export USE_CELERY="True"
export CELERY_BROKER="redis://127.0.0.1:6379/2"
export CELERY_BACKEND="redis://127.0.0.1:6379/2"

# Sync exercises and images via Celery
export WGER_INSTANCE="https://wger.de"
export SYNC_EXERCISES_CELERY="True"
export SYNC_EXERCISE_IMAGES_CELERY="True"
export SYNC_EXERCISE_VIDEOS_CELERY="True"

# Persistent media storage
mkdir -p /data/wger/media /data/wger/beat
chown -R wger:wger /data/wger
rm -rf /home/wger/media 2>/dev/null || true
ln -sf /data/wger/media /home/wger/media
ln -sf /data/wger/beat /home/wger/beat

# Start Redis in the background
redis-server --daemonize yes --bind 127.0.0.1 --port 6379 \
    --dir /var/lib/redis --pidfile /var/run/redis/redis.pid

# Start Celery worker in the background (as wger user)
cd /home/wger/src
gosu wger celery -A wger worker --loglevel=info --detach \
    --pidfile=/tmp/celery-worker.pid --logfile=/tmp/celery-worker.log

# Start Celery beat in the background (as wger user)
gosu wger celery -A wger beat --loglevel=info --detach \
    --pidfile=/tmp/celery-beat.pid --logfile=/tmp/celery-beat.log \
    --schedule=/data/wger/beat/celerybeat-schedule

echo "Starting wger..."
exec gosu wger /home/wger/entrypoint.sh
