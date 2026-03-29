# FMD Home Assistant Add-on
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

This add-on runs [FMD](https://fmd-foss.org/) inside Home Assistant OS.

This addon has access to the addon_config folder.

## Installation
[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpaalwilliams%2Fhomeassistant-addons)

Install the **FMD** add-on from this repo and start it.

Please note: you will need to use a reverse proxy in order for this to work. I recommend [Nginx Proxy Manager](https://github.com/hassio-addons/addon-nginx-proxy-manager).
To fix the 403 error with OSM, you will need to add some custom configuration in the `advanced` section of your Proxy Host. 

```
location / {
    proxy_pass $forward_scheme://$server:$port;

    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_set_header Referer $scheme://$host;

    # optional but recommended
    add_header Referrer-Policy "strict-origin-when-cross-origin";
}
```
