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
- **SYNC_EXERCISES_ON_STARTUP**: Pull the exercise database from wger.de on every
  start (default: false). A fresh install only has the snapshot baked into the
  fixtures, and the Celery sync then runs weekly at a random time, so it can be
  days before new exercises appear. Turn this on for the first start, or when you
  need an exercise that is missing, then turn it off again — it adds a minute or
  two to every startup.
- **DOWNLOAD_EXERCISE_IMAGES_ON_STARTUP**: Same, for exercise images (default:
  false). Slow, and only useful together with the option above.
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

Create the role and database as a superuser (`postgres`), from any database:

```sql
CREATE ROLE wger WITH LOGIN PASSWORD 'change-me';
CREATE DATABASE wger WITH OWNER = wger ENCODING = 'UTF8' TEMPLATE = template0;
```

Then connect **to the `wger` database**, still as a superuser, and run:

```sql
CREATE PUBLICATION powersync FOR ALL TABLES;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;
GRANT ALL ON SCHEMA public TO wger;
```

The publication is the one that is easy to miss. Migration `core.0023` creates it
for PowerSync (the mobile app's offline sync), and `FOR ALL TABLES` publications
are superuser-only in PostgreSQL — owning the database is not enough. Creating it
up front makes that migration a no-op, which is preferable to granting the `wger`
role superuser. The extensions are needed by the full text search migration; they
are trusted extensions on PostgreSQL 13+, so the migration can create them itself,
but creating them here does no harm.

## Notes

- Redis, Celery (for background tasks like exercise syncing) and nginx are bundled
  inside the addon. nginx listens on port 8000 and serves `/static/` and `/media/`,
  proxying everything else to gunicorn — wger does not serve those itself in
  production mode.
- Exercise data is synced from wger.de in the background by Celery.
- Media files are persisted in `/data/wger/media`, generated secrets in
  `/data/wger/secrets.env`.
