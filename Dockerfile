FROM ghcr.io/cloudflare/pint:0.65.3
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
