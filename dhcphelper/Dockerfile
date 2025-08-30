FROM alpine:latest

LABEL author="cyb3rdoc" maintainer="cyb3rdoc@proton.me"

RUN apk update \
    && apk add --no-cache \
    dhcp-helper \
    tzdata \
    && rm -rf /var/cache/apk/*

ENV IP=""
ENV TZ=UTC

EXPOSE 67/udp

HEALTHCHECK CMD nc -uzvw3 127.0.0.1 67 || exit 1

ENTRYPOINT ["sh", "-c", "exec dhcp-helper -n -s ${IP:-NODATA}"]
