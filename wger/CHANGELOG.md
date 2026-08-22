# Changelog

## 2.6.2

- Trust the forwarded headers the bundled nginx already sets
  (`X_FORWARDED_PROTO_HEADER_SET`, `USE_X_FORWARDED_HOST`). Without them wger
  built absolute URLs from the wrong host, so API pagination links pointed
  somewhere else and the mobile app warned about a server misconfiguration

## 2.6.1

Add-on fixes, on the same upstream wger 2.6.0 image.

- Generate the JWT keypair directly instead of through `manage.py`, so startup
  no longer loads django before the database is reachable, and bound it with a
  timeout
- Check that postgres is reachable and that the database can actually be opened
  before starting. A wrong host, wrong password, missing database or missing
  powersync publication now fails with postgres' own error, instead of hanging
  or a hundred lines of traceback
- Run a single gevent celery worker instead of a prefork pool per core
- Add `SYNC_EXERCISES_ON_STARTUP` and `DOWNLOAD_EXERCISE_IMAGES_ON_STARTUP`,
  so a fresh install does not wait up to a week for the celery job
- Document the full database setup, including the powersync publication

## 2.6.0

- Update to wger 2.6.0 and pin the upstream image tag (`latest` currently points at a
  2.7 alpha)
- Bundle nginx to serve `/static/` and `/media/`, which gunicorn does not serve with
  `DJANGO_DEBUG=False`
- Replace the `SIGNING_KEY` option, removed in wger 2.6, with `JWT_PRIVATE_KEY` /
  `JWT_PUBLIC_KEY`
- Generate and persist `SECRET_KEY` and the JWT keypair on first start, so sessions
  and tokens survive restarts. The keypair is generated directly instead of through
  `manage.py`, so startup does not depend on the database or redis being reachable,
  and is bounded by a timeout
- Check that postgres is reachable and that the database can actually be opened
  before starting, and set `PGCONNECT_TIMEOUT`, so a wrong host, password or
  missing database fails with postgres' own error instead of hanging silently
- Run a single gevent celery worker, matching upstream, instead of forking a
  prefork pool per core
- Check for the powersync publication before starting. Migration `core.0023`
  needs superuser to create it, and failed with a hundred lines of traceback
- Document the full database setup, including the publication
- Add `SYNC_EXERCISES_ON_STARTUP` and `DOWNLOAD_EXERCISE_IMAGES_ON_STARTUP`
  options, so a fresh install does not have to wait for the weekly celery job
- Add a `CSRF_TRUSTED_ORIGINS` option

## 2.5.0

- Initial release
- wger workout manager with bundled Redis and Celery
- Requires external PostgreSQL database
