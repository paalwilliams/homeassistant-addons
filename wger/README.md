# Home Assistant Add-on: wger

A free, open source web application for managing your workouts and nutrition.

## Configuration

### Required

- **SECRET_KEY**: Django secret key for cryptographic signing. Generate a random string.
- **SIGNING_KEY**: JWT signing key. Should differ from SECRET_KEY.
- **DJANGO_DB_HOST**: PostgreSQL database host (e.g. `core-postgresql` or an external IP).
- **DJANGO_DB_DATABASE**: PostgreSQL database name.
- **DJANGO_DB_USER**: PostgreSQL user.
- **DJANGO_DB_PASSWORD**: PostgreSQL password.

### Optional

- **ALLOW_REGISTRATION**: Allow new user registration (default: true).
- **ALLOW_GUEST_USERS**: Allow guest access (default: true).
- **SITE_URL**: The URL users will access wger at.
- **TZ**: Timezone (default: America/Los_Angeles).

## Database Setup

This addon requires an external PostgreSQL database. You can use the
[PostgreSQL addon](https://github.com/home-assistant/addons/tree/master/postgres)
or any external PostgreSQL instance.

Create a database and user for wger before starting the addon.

## Notes

- Redis and Celery (for background tasks like exercise syncing) are bundled inside the addon.
- Exercise data is automatically synced from wger.de on first start.
- Media files are persisted in `/data/wger/media`.
