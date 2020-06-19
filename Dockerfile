FROM balenalib/amd64-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Gabriele Besta <48332305+bg-master@users.noreply.github.com>" \
    org.opencontainers.image.title="balenalib-amd64-alpine-mosquitto" \
    org.opencontainers.image.description="Eclipse Mosquitto MQTT broker based on balena.io Alpine base image" \
    org.opencontainers.image.authors="Gabriele Besta <48332305+bg-master@users.noreply.github.com>" \
    org.opencontainers.image.vendor="BGdev.it" \
    org.opencontainers.image.version="1.0.0" \
    org.opencontainers.image.url="https://hub.docker.com/repository/docker/bgdevit/balenalib-amd64-alpine-mosquitto" \
    org.opencontainers.image.source="https://github.com/bgdev-it/balenalib-amd64-alpine-mosquitto" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

WORKDIR /mosquitto

COPY config ./

RUN set -xe && \
    addgroup -S -g 1883 mosquitto 2>/dev/null && \
    adduser -S -u 1883 -D -H -h /var/empty -s /sbin/nologin -G mosquitto -g mosquitto mosquitto 2>/dev/null && \
    install_packages \
        mosquitto \
        mosquitto-libs \
        mosquitto-clients \
        tzdata \
        ca-certificates && \
    mkdir config data log && \
    install -m644 mosquitto.conf.default config/mosquitto.conf && \
    chown -R mosquitto:mosquitto /mosquitto && \
    rm -rf /var/cache/apk/* /tmp/*

VOLUME ["/mosquitto"]

EXPOSE 1883

# Set up the entry point script and default command
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
