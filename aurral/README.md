# Aurral

[Aurral](https://aurral.org/) is self-hosted music discovery: recommendations,
rotating flows, playlist imports (Spotify, YouTube Music, Deezer, Last.fm,
ListenBrainz), a web player and a Subsonic server at `/rest`. It works on its
own or alongside Lidarr.

## Folders

| In Aurral | Comes from |
|---|---|
| `/config` | this app's config folder: database, settings, users, jobs |
| `/media` | Home Assistant's media folder, including USB drives mounted there |
| `/share` | Home Assistant's share folder, including network mounts |

Enter container paths (`/media/...`, `/share/...`) in Aurral's settings.

- **Lidarr:** if Lidarr's root folder is under `/media`, Aurral sees the same
  files at the same path.
- **slskd:** if slskd reports paths like `/downloads/...` and its downloads
  folder is mounted at `/share/slskd`, add a remote path mapping in
  *Settings > Download clients > Remote path mappings* from `/downloads` to
  `/share/slskd`, applying to slskd.
- **Downloads Folder:** pick a folder on the drive that holds your music, e.g.
  `/media/<drive>/aurral`, so downloads don't fill up the system disk.

## Options

- `PUID` / `PGID`: user and group Aurral runs as. `0` (root) can write to
  `/media` and `/share`, which belong to root on Home Assistant OS.
- `TZ`: timezone, e.g. `Europe/Berlin`.
- `env_vars`: extra environment variables for Aurral, e.g. `OIDC_*` or
  `AUTH_PROXY_*` for single sign-on.

The web interface listens on port 3001 inside the app. Put a reverse proxy in
front of it, or map the port in the app's network settings.
