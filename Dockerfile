# syntax=docker/dockerfile:1.6
FROM ubuntu:22.04

# Add build args for version and icon URL (adjust defaults)
ARG ASHI_VERSION=1.0.0
ARG ICON_URL="https://raw.githubusercontent.com/TheNymMan/Ashi-T/main/assets/icon.png"
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates tmux ttyd tini gosu procps tor torsocks \
    && rm -rf /var/lib/apt/lists/*

# If building the arm64 variant, enable dpkg multiarch so apt can resolve
# amd64 dependencies during install. We rely on host binfmt for runtime emulation.
RUN set -eux; \
  if [ "${TARGETARCH:-}" = "arm64" ]; then \
    dpkg --add-architecture amd64; \
    # Tell apt to consider both arches
    echo 'APT::Architectures "arm64;amd64";' > /etc/apt/apt.conf.d/00arch; \
    apt-get update; \
  fi; \
  rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -u 1000 -s /bin/bash ashigaru

# Bring in artifacts (the workflow fetches these)
# amd64 .deb is used for both variants; arm64 runs it via qemu + multiarch libs
COPY ./artifacts/ashigaru_terminal_v${ASHI_VERSION}_amd64.deb /tmp/ashigaru_amd64.deb

# Install the amd64 package (works on amd64; on arm64 relies on multiarch)
RUN set -eux; \
  dpkg -i /tmp/ashigaru_amd64.deb || \
    (apt-get update && apt-get -f install -y && rm -rf /var/lib/apt/lists/*); \
  rm -f /tmp/ashigaru_amd64.deb

# Runtime env
ENV TERM=xterm-256color \
    TMUX_SESSION=ashigaru \
    PORT=7682 \
    ASHIGARU_CMD=/opt/ashigaru-terminal/bin/Ashigaru-terminal \
    TOR_SOCKS_LISTEN=127.0.0.1 \
    TOR_SOCKS_PORT=9050 \
    TOR_CONTROL_ENABLE=0 \
    TOR_CONTROL_LISTEN=127.0.0.1 \
    TOR_CONTROL_PORT=9051 \
    TOR_DATADIR=/home/ashigaru/.tor

# Entrypoint
COPY ./docker_entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 7682
EXPOSE 9050
EXPOSE 9051

WORKDIR /home/ashigaru
USER ashigaru

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
