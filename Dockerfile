FROM ghcr.io/thenymman/ashi-t:latest

USER root
COPY ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/docker_entrypoint.sh"]
