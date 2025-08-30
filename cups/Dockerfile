FROM alpine:3.20

LABEL author="cyb3rdoc" maintainer="cyb3rdoc@proton.me"

RUN apk add --no-cache \
    cups cups-client cups-libs cups-filters \
    ghostscript \
    sane sane-backends sane-dev \
    avahi avahi-tools avahi-dev \
    dbus \
    wget curl shadow \
    hplip \
    && rm -rf /var/cache/apk/* /tmp/*

RUN adduser -D -h /var/lib/cups -s /bin/sh cups || true && \
    adduser cups lpadmin || true && \
    adduser cups lp || true && \
    adduser -D -h /var/lib/saned -s /sbin/nologin saned || true && \
    adduser saned scanner || true

RUN mkdir -p /var/run/cups /var/log/cups /var/lib/saned /run/dbus

COPY cupsd.conf /etc/cups/cupsd.conf
COPY saned.conf /etc/sane.d/saned.conf
COPY entrypoint.sh /entrypoint.sh

RUN echo '#!/bin/sh\nexec /usr/sbin/saned -d' > /usr/local/bin/saned-service && \
    chmod +x /usr/local/bin/saned-service

RUN chmod +x /entrypoint.sh && \
    chmod 644 /etc/cups/cupsd.conf && \
    chmod 644 /etc/sane.d/saned.conf && \
    chown root:root /etc/cups/cupsd.conf && \
    chown root:root /etc/sane.d/saned.conf

ENV TZ=UTC

EXPOSE 631 6566

WORKDIR /etc/cups

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:631/ || exit 1

CMD ["/entrypoint.sh"]
