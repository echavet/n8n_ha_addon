ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    nodejs \
    npm \
    jq

RUN npm install -g n8n

EXPOSE 5678
WORKDIR /data

COPY rootfs /

RUN find /etc/s6-overlay/s6-rc.d/ -name "run" -exec chmod +x {} \;

ENV __BASHIO_LOG_LEVEL=1