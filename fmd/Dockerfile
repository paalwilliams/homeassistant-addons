ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

LABEL maintainer="Paal <paaa.al@proton.me>" 
LABEL io.hass.version=${BUILD_VERSION} 
LABEL io.hass.type="addon" 
LABEL io.hass.arch="aarch64|amd64"

USER root

COPY --chmod=755 run.sh /

EXPOSE 8080

ENTRYPOINT []
CMD [ "/run.sh" ]
