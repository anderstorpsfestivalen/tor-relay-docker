FROM ghcr.io/linuxserver/baseimage-alpine:edge

LABEL maintainer "DENNIS <dennis@gmail.com>"

ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config"
ENV TZ America/Los_Angeles

RUN apk --no-cache add bash tzdata tor

EXPOSE 9001 9030

# TOR configuration through environment variables.
ENV RELAY_TYPE relay
ENV TOR_ORPort 9001
ENV TOR_DirPort 9030
ENV TOR_DataDirectory /data
ENV TOR_ContactInfo "KORVERIK korv@anderstorpsfestivalen.se"
ENV TOR_RelayBandwidthRate "100 MBits"
ENV TOR_RelayBandwidthBurst "200 MBits"

# Copy the default configurations.
COPY torrc.bridge.default /config/torrc.bridge.default
COPY torrc.relay.default /config/torrc.relay.default
COPY torrc.exit.default /config/torrc.exit.default

COPY entrypoint.sh /entrypoint.sh
RUN chmod ugo+rx /entrypoint.sh

COPY /root /
RUN chmod ugo+rx /etc/cont-init.d/30-config /etc/services.d/tor/run

VOLUME /data
