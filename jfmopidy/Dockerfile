FROM alpine:latest

LABEL author="cyb3rdoc" maintainer="cyb3rdoc@proton.me"

RUN mkdir /etc/default && mkdir /etc/mopidy

COPY mopidy.conf /etc/default/mopidy.conf

COPY entrypoint.sh /entrypoint.sh

RUN apk update \
  && apk add --no-cache \
  curl \
  py3-gst \
  gst-plugins-base \
  gst-plugins-good \
  gst-plugins-bad \
  gst-plugins-ugly \
  python3 \
  mopidy \
  && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing py3-mopidy-jellyfin \
  && rm -rf /var/cache/apk/*

VOLUME ["/etc/mopidy", "/var/lib/mopidy"]

ENV TZ=UTC

EXPOSE 6600 6680

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=5s --timeout=2s --retries=20 \
    CMD curl --connect-timeout 5 --silent --show-error --fail http://localhost:6680/ || exit 1
