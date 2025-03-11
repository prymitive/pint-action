FROM ghcr.io/cloudflare/pint:0.71.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
