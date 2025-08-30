FROM alpine:latest

LABEL author="cyb3rdoc" maintainer="cyb3rdoc@proton.me"

RUN apk add --no-cache \
    kea \
    kea-dhcp4 \
    kea-ctrl-agent

RUN adduser -D -u 1000 kea 2>/dev/null || true && \
    mkdir -p /var/lib/kea /var/log/kea && \
    chown -R kea:kea /var/lib/kea /var/log/kea

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV TZ=UTC

VOLUME ["/etc/kea"]

EXPOSE 67/udp

ENTRYPOINT ["/entrypoint.sh"]
