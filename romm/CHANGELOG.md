<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 5.3.1.2

- Add optional single sign-on (OpenID Connect) settings: `OIDC_ENABLED`,
  `OIDC_PROVIDER`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`, `OIDC_REDIRECT_URI`,
  `OIDC_SERVER_APPLICATION_URL`, `OIDC_SERVER_METADATA_URL`, `OIDC_AUTOLOGIN`,
  `OIDC_ALLOW_REGISTRATION` and `DISABLE_USERPASS_LOGIN`
- Pass boolean options to RomM as `true`/`false`

## 5.3.1.1

- Run one API worker and scan two ROMs at a time instead of four each,
  cutting memory use from about 1 GB to a few hundred MB

## 4.7.0.0

- Version now follows `<upstream version>.<add-on revision>`; no functional change

## 1.0.0

- Initial release
