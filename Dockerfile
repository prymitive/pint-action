FROM ghcr.io/cloudflare/pint:0.46.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
