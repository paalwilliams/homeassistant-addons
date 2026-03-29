# RomM Home Assistant Add-on
![Project Stage][project-stage-shield]

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

![Project Maintenance][maintenance-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[armv7-shield]: https://img.shields.io/badge/armv7-no-red.svg
[i386-shield]: https://img.shields.io/badge/i386-no-red.svg

[commits]: https://github.com/paalwilliams/homeassistant-addons/commits/main
[issue]: https://github.com/paalwilliams/homeassistant-addons/issues
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[releases]: https://github.com/paalwilliams/homeassistant-addons/releases
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg

This add-on runs [RomM](https://github.com/rommapp/romm) inside Home Assistant OS.

RomM is a beautiful, powerful ROM manager for your retro game collection. It allows you to scan, manage, and browse your ROMs with rich metadata from IGDB, MobyGames, and other sources.

This addon has access to the media, addon_config, and share folders.

## Prerequisites

- **MariaDB**: RomM requires a MariaDB database. Install the [MariaDB add-on](https://github.com/home-assistant/addons/tree/master/mariadb) and create a database and user for RomM.
- **Auth Secret Key**: Generate one with `openssl rand -hex 32`.

## Configuration

| Option | Description |
|---|---|
| `ROMM_AUTH_SECRET_KEY` | Secret key for authentication (required) |
| `ROMM_AUTH_USERNAME` | Initial admin username (default: admin) |
| `ROMM_AUTH_PASSWORD` | Initial admin password |
| `DB_HOST` | MariaDB host (default: core-mariadb) |
| `DB_PORT` | MariaDB port (default: 3306) |
| `DB_NAME` | Database name (default: romm) |
| `DB_USER` | Database user (default: romm) |
| `DB_PASSWD` | Database password |
| `ROMM_BASE_PATH` | Path to your ROM library (default: /media/romm) |
| `IGDB_CLIENT_ID` | IGDB API client ID (optional, for metadata) |
| `IGDB_CLIENT_SECRET` | IGDB API client secret (optional) |
| `SCREENSCRAPER_USER` | ScreenScraper username (optional) |
| `SCREENSCRAPER_PASSWORD` | ScreenScraper password (optional) |
| `MOBYGAMES_API_KEY` | MobyGames API key (optional) |
| `STEAMGRIDDB_API_KEY` | SteamGridDB API key (optional) |
| `TZ` | Timezone (default: America/Los_Angeles) |

## Installation
[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpaalwilliams%2Fhomeassistant-addons)

Install the **RomM** add-on from this repo and start it.
