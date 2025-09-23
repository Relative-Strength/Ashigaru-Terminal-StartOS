############################
# Stage 1: build/runtime filesystem
############################
FROM ubuntu:22.04 AS buildstage
ARG ASHI_VERSION=1.0.0

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates tmux ttyd tini gosu procps tor torsocks \
    && rm -rf /var/lib/apt/lists/*

# Enable amd64 multiarch when building the arm64 variant so apt can resolve
# amd64 dependencies for the upstream .deb
RUN set -eux; \
  if [ "${TARGETARCH:-}" = "arm64" ]; then \
    dpkg --add-architecture amd64; \
    echo 'APT::Architectures "arm64;amd64";' > /etc/apt/apt.conf.d/00arch; \
    apt-get update; \
  fi

# Non-root runtime user
RUN useradd -m -u 1000 -s /bin/bash ashigaru

# Bring in the pre-downloaded artifact (place it in ./artifacts in your repo)
COPY ./artifacts/ashigaru_terminal_v${ASHI_VERSION}_amd64.deb /tmp/ashigaru_amd64.deb

# Install the amd64 package (works on amd64; on arm64 relies on multiarch)
RUN set -eux; \
  dpkg -i /tmp/ashigaru_amd64.deb || \
    (apt-get update && apt-get -f install -y); \
  rm -f /tmp/ashigaru_amd64.deb; \
  rm -rf /var/lib/apt/lists/*

# Entrypoint script
COPY ./docker_entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /home/ashigaru
USER ashigaru

############################
# Stage 2: final image (StartOS-style)
############################
FROM scratch

# Copy full filesystem from build stage (like the StartOS example)
COPY --from=buildstage / /

# Runtime env (unchanged behavior)
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

# Ports (unchanged)
EXPOSE 7682
EXPOSE 9050
EXPOSE 9051

# Runtime user and working directory (re-declared for final image)
WORKDIR /home/ashigaru
USER ashigaru

# Entrypoint (unchanged)
ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/docker-entrypoint.sh"]

# Optional persistence (recommended)
VOLUME /home/ashigaru
