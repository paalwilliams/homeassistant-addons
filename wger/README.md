# Home Assistant Add-on: wger

A free, open source web application for managing your workouts and nutrition.

Based on the official [wger/server](https://hub.docker.com/r/wger/server) image
(pinned to 2.6.0), with Redis, Celery and nginx bundled inside the add-on.

## Configuration

### Required

- **DJANGO_DB_HOST**: PostgreSQL database host (e.g. `core-postgresql` or an external IP).
- **DJANGO_DB_DATABASE**: PostgreSQL database name.
- **DJANGO_DB_USER**: PostgreSQL user.
- **DJANGO_DB_PASSWORD**: PostgreSQL password.

### Optional

- **SECRET_KEY**: Django secret key for cryptographic signing. Leave empty and one is
  generated on first start and stored in `/data/wger/secrets.env`.
- **JWT_PRIVATE_KEY** / **JWT_PUBLIC_KEY**: RS256 keypair used for the mobile app's JWT
  authentication. Leave empty and a keypair is generated on first start and stored in
  `/data/wger/secrets.env`. Only set these if you are migrating an existing install.
- **ALLOW_REGISTRATION**: Allow new user registration (default: true).
- **ALLOW_GUEST_USERS**: Allow guest access (default: true).
- **SITE_URL**: The URL users will access wger at. Used to build absolute links to
  uploaded images, so set it to the address you actually use.
- **CSRF_TRUSTED_ORIGINS**: Comma-separated list of origins allowed to submit forms.
  Needed if you reach wger through a reverse proxy or a different hostname than
  `SITE_URL`, otherwise logins fail with a CSRF error.
- **TZ**: Timezone (default: America/Los_Angeles).

## Database Setup

This addon requires an external PostgreSQL database. You can use the
[PostgreSQL addon](https://github.com/home-assistant/addons/tree/master/postgres)
or any external PostgreSQL instance.

Create a database and user for wger before starting the addon.

## Notes

- Redis, Celery (for background tasks like exercise syncing) and nginx are bundled
  inside the addon. nginx listens on port 8000 and serves `/static/` and `/media/`,
  proxying everything else to gunicorn — wger does not serve those itself in
  production mode.
- Exercise data is synced from wger.de in the background by Celery.
- Media files are persisted in `/data/wger/media`, generated secrets in
  `/data/wger/secrets.env`.
