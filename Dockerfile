FROM ghcr.io/cloudflare/pint:0.71.5
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
