# Changelog

## 1.0.0

- Initial release
- Wraps the official `rssbridge/rss-bridge:latest` image
- Config persisted in the add-on config share (`/config`), seeded with a default
  `config.ini.php` that enables per-feed `_cache_timeout` to reduce rate limiting
- No database required
