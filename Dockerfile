FROM ghcr.io/cloudflare/pint:0.58.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
