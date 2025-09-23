FROM ghcr.io/thenymman/ashi-t:latest

COPY --chmod=0755 ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/docker_entrypoint.sh"]
