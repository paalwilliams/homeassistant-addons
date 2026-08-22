ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_VERSION

LABEL maintainer="Paal <paaa.al@proton.me>"
LABEL io.hass.version=${BUILD_VERSION}
LABEL io.hass.type="addon"
LABEL io.hass.arch="aarch64|amd64"

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends redis-server gosu nginx-light \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/redis /var/lib/redis \
    && chown wger:wger /var/run/redis /var/lib/redis \
    && rm -f /etc/nginx/sites-enabled/default \
    && sed -i 's/^user .*/user wger;/' /etc/nginx/nginx.conf \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chown -R wger:wger /var/lib/nginx /var/log/nginx

COPY nginx.conf /etc/nginx/conf.d/wger.conf
COPY --chmod=755 gen-jwt-keys.py /usr/local/bin/wger-gen-jwt-keys
COPY --chmod=755 run.sh /

EXPOSE 8000

ENTRYPOINT []
CMD [ "/run.sh" ]
