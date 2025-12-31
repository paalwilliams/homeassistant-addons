# Audiobookshelf Home Assistant Add-on
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
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[releases]: https://github.com/paalwilliams/homeassistant-addons/releases
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg

This add-on runs [Audiobookshelf](https://www.audiobookshelf.org/) inside Home Assistant OS.

This addon has access to the addon_config, backup, media, and share folders.  
AudioBookShelf Version 2.32.1

## Installation
[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpaalwilliams%2Fhomeassistant-addons)

Install the **Audiobookshelf** add-on from this repo and start it.

If you want to use a network drive please add it to homeassistant in Network Storage with the media usage option.

## Configuration

- **CONFIG_PATH** (default: /config)
  - Path to the config directory.
  - It will contain the database (users/books/libraries/settings). This location must not be mounted over the network.

- **METADATA_PATH** (default: /metadata)
  - Path to the metadata directory.
  - It will contain cache, streams, covers, downloads, backups and logs.

- **BACKUP_PATH** (default: /metadata/backups)
  - Path to where backups are stored.
  - Backups contain a backup of the database in /config and images/metadata stored in /metadata/items and /metadata/authors

- **ALLOW_CORS** (default: '0')
  - Allow Cross-Origin Resource Sharing if set to '1'.

- **ALLOW_IFRAME** (default: '1')
  - Allow use of iframes. This can also be done at the reverse proxy level.

- **ACCESS_TOKEN_EXPIRY** (default: '43200')
  - Access token expiration in seconds (default: 43200 = 12 hours)

- **REFRESH_TOKEN_EXPIRY** (default: '604800')
  - Refresh token expiration in seconds (default: 604800 = 7 days)


## Disclaimers and copyright information

This is a fork of [this project](https://github.com/bigred10151990/audiobookshelfserver) by [bigred10151990](https://github.com/bigred10151990). All original licenses apply.

Audiobookshelf  Self-hosted audiobook server
Copyright (C) 2021  advplyr

This program comes with ABSOLUTELY NO WARRANTY
