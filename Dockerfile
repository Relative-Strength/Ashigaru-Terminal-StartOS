FROM ghcr.io/relative-strength/ashigaru-terminal-image-startos:latest

USER root
COPY ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/docker_entrypoint.sh"]
