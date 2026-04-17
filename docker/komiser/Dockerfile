FROM tailwarden/komiser:latest

USER root

COPY entrypoints.sh /usr/local/bin/entrypoints.sh
RUN chmod +x /usr/local/bin/entrypoints.sh

ENTRYPOINT ["/usr/local/bin/entrypoints.sh"]
CMD ["start"]
