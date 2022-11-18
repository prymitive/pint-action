FROM ghcr.io/cloudflare/pint:0.34.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
