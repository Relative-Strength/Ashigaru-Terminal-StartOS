FROM ghcr.io/relative-strength/ashigaru-terminal-image-startos:latest

COPY --chmod=0755 ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/docker_entrypoint.sh"]
