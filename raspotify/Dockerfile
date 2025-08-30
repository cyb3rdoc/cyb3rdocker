FROM debian:stable-slim

LABEL author="cyb3rdoc" maintainer="cyb3rdoc@proton.me"

RUN set -ex \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	curl \
	apt-transport-https \
	dumb-init \
	gnupg \
  && curl -sSL https://dtcooper.github.io/raspotify/key.asc | gpg --dearmor -o /usr/share/keyrings/raspotify-keyring.gpg \
  && echo 'deb [signed-by=/usr/share/keyrings/raspotify-keyring.gpg] https://dtcooper.github.io/raspotify raspotify main' | tee /etc/apt/sources.list.d/raspotify.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	raspotify \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

ENV TZ=UTC
ENV SPOTIFY_NAME=raspotify

CMD ["/usr/bin/dumb-init", "--", "/usr/bin/librespot", "--name", "$SPOTIFY_NAME", "--backend", "alsa", "--bitrate", "320", "--disable-audio-cache"]
