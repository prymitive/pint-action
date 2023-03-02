FROM ghcr.io/cloudflare/pint:0.41.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
