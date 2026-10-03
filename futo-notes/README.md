# FUTO Notes

Self-hosted sync server for [FUTO Notes](https://notes.futo.tech/). Notes are
encrypted on your devices before upload; the server only stores sealed blobs.

## Setup

1. Set a `password` in the app configuration. The same sync password is used
   on every device and unlocks the encryption key for your notes.
2. Start the app.
3. In FUTO Notes, point sync at `http://<home-assistant-ip>:3005`, or at the
   HTTPS address of a reverse proxy in front of port 3005.

The server is single-user: one sync password, one vault.

Data (SQLite database and encrypted blobs) lives in this app's `addon_config`
folder, so it is included in Home Assistant backups.
