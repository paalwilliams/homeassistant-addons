# Changelog

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
- Check that postgres is reachable before starting, and set `PGCONNECT_TIMEOUT`, so
  an unreachable database fails with a clear message instead of hanging silently
- Add a `CSRF_TRUSTED_ORIGINS` option

## 2.5.0

- Initial release
- wger workout manager with bundled Redis and Celery
- Requires external PostgreSQL database
