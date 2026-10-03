ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

LABEL maintainer="Paal <paaa.al@proton.me>"
LABEL io.hass.version=${BUILD_VERSION}
LABEL io.hass.type="addon"
LABEL io.hass.arch="aarch64|amd64"

USER root

# tzdata provides /usr/share/zoneinfo so the configurable TZ resolves
RUN apt-get update && apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 run.sh /

EXPOSE 3000

ENTRYPOINT []
CMD [ "/run.sh" ]
