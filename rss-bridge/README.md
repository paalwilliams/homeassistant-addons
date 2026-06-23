# Home Assistant Add-on: RSS-Bridge

Self-hosted [RSS-Bridge](https://github.com/RSS-Bridge/rss-bridge) — generates
RSS/Atom feeds for sites that don't offer them (Instagram, and ~200 others).

Running your own instance avoids the rate-limiting and `400`/`429` errors that
plague public RSS-Bridge instances, which is the reliable way to feed Instagram
accounts into FreshRSS.

## Installation

1. Add this repository to **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   (if not already added): `https://github.com/paalwilliams/homeassistant-addons`
2. Install **RSS-Bridge**, then **Start** it.
3. Open the Web UI (sidebar panel, or `http://<ha-host>:3000`).

## Configuration

### Options

- **TZ**: Timezone for feed/log timestamps (default: `America/Los_Angeles`).

That's it — RSS-Bridge needs no database and no required secrets.

### Advanced config (optional)

Files placed in this add-on's config share are copied into RSS-Bridge on every
start (so they persist across restarts and updates). Edit them via Samba or the
File Editor add-on under `/addon_configs/<repo>_rss-bridge/`:

| File | Purpose |
|------|---------|
| `config.ini.php` | Overrides default settings. Seeded on first start. |
| `whitelist.txt`  | Restrict which bridges are enabled (one per line; `*` = all). |
| `*Bridge.php`    | Drop in custom/extra bridges. |

The seeded `config.ini.php` enables `custom_timeout`, which lets each feed URL
request a longer cache via `&_cache_timeout=<seconds>`. Longer caches mean fewer
upstream scrapes and far fewer Instagram `429` rate-limit errors.

## Using it with FreshRSS / the Instagram sync script

Point the sync script's bridge base at this add-on instead of the public one.
In `freshrss.env`:

```sh
RSSBRIDGE_BASE=http://<ha-host>:3000
```

New subscriptions will then be fetched through your own bridge. Existing feeds
that point at the old public instance keep their old URL — delete and re-add
them (or re-run the sync after removing them) to move them over.

## Notes

- The web server (nginx + php-fpm) is provided by the upstream
  `rssbridge/rss-bridge` image; this add-on only wires up config persistence and
  the timezone.
- Lightweight: no database, near-zero idle CPU, ~30–80 MB RAM. Work happens only
  when a feed is fetched.
