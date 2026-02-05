FROM ghcr.io/cloudflare/pint:0.79.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
